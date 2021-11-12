//
//  ContentView.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/6.
//

import SwiftUI
import CoreData
import Moya

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: []
    ) private var settings: FetchedResults<Settings>
    
    private let provider = MoyaProvider<MultiTarget>()
    private let persistenceController = PersistenceController.shared
    
    @State private var isCardIDNotSet: Bool = true
    @State private var isUserDataFetched: Bool = false
    @State private var isWrongCard: Bool = false
    @State private var userName: String?
    @State private var userTeamName: String?
    @State private var userLevel: String?
    @State private var userRating: String?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: PlayerDataView()) {
                        VStack {
                            HStack {
                                Text(userTeamName ?? (isUserDataFetched ? "未设置队伍名" : "")) // Team
                                Spacer()
                                Text(userLevel == nil ? "" : "Lv." + userLevel!) // Lv
                            }
                            HStack {
                                if !isCardIDNotSet {
                                    Text(userName ?? (isWrongCard ? "卡号错误/没有数据" : "加载中...")) // Name
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .onAppear(perform: {
                                            getUserData()
                                            getGeneralData()
                                        })
                                } else {
                                    Text("未设置卡号")
                                        .font(.title)
                                        .fontWeight(.bold)
                                }
                                Spacer()
                                if let userRating = userRating {
                                    let rating = String(format: "%.2f", convertRating(userRating))
                                    let rawRating = Int(userRating)!
                                    if rawRating >= 1500 {
                                        Text(rating)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .modifier(RainbowRatingText())
                                    } else {
                                        Text(rating)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(getColorByRating(rawRating))
                                    }
                                }
                            }
                        }
                        .padding([.top, .leading, .bottom])
                    }
                }
                
                Section(header: Text("RATING分析")) {
                    NavigationLink(destination: B30View()) {
                        HStack {
                            Text("Best 30")
                            Spacer()
                            Text("B30 Rating") // B30 RT
                                .foregroundColor(Color.gray)
                        }
                    }
                    NavigationLink(destination: R10View()) {
                        HStack {
                            Text("Recent 10")
                            Spacer()
                            Text("R10 Rating") // R10 RT
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: RecentPlayView()) {
                        Text("最近游玩记录")
                    }
                    NavigationLink(destination: ModTicketCountView()) {
                        Text("道具数量修改")
                    }
                }
                
                Section(header: Text("设定")) {
                    NavigationLink(destination: ChangeCardIDView()
                                    .onAppear(perform: { reinit() })) {
                        Text("修改卡号")
                        Spacer()
                    }
                    NavigationLink(destination: ChangeServerView()) {
                        Text("修改服务器")
                        Spacer()
                    }
                }
                
                Section(footer: Text("请在曲目详细信息显示异常的情况下使用此功能")) {
                    Button(action: { getSongList() }) {
                        Text("刷新曲目数据库")
                    }
                }
            }
            .sheet(isPresented: $isCardIDNotSet) {
                NavigationView {
                    ChangeCardIDView()
                        .onDisappear {
                            isCardIDNotSet = !(settings[0].card! == "" ? false : true)
                        }
                }
            }
            .navigationTitle("ChuniQuery")
            .onAppear {
                if settings.count == 0 {
                    let newSetting = Settings(context: viewContext)
                    newSetting.url = "http://123.57.246.220:3000" // Defaults to BBS
                    newSetting.card = ""
                    newSetting.songList = nil
                    persistenceController.save()
                }
                
                if settings[0].songList == nil {
                    getSongList()
                }
                
                isCardIDNotSet = !(settings[0].card! == "" ? false : true)
            }
        }
    }
    
    private func reinit() {
        DispatchQueue.main.async {
            userName = nil
            userTeamName = nil
            userLevel = nil
            userRating = nil
            isUserDataFetched = false
            isWrongCard = false
        }
    }
    
    private func getUserData() {
        provider.request(MultiTarget(MinimeSupportAPI.getUserData(baseURL: self.settings[0].url!, cardID: self.settings[0].card!))) { result in
            switch result {
            case .success(let resp):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let userData: UserDataElements
                do {
                    userData = try decoder.decode(UserDataModel.self, from: resp.data)[0]
                } catch {
                    DispatchQueue.main.async {
                        isWrongCard = true
                    }
                    return
                }
                DispatchQueue.main.async {
                    userName = userData.userName
                    userLevel = userData.level
                    userRating = userData.playerRating
                    isUserDataFetched = true
                    isWrongCard = false
                }
            case .failure(_):
                return
            }
        }
    }
    
    private func getGeneralData() {
        provider.request(MultiTarget(MinimeSupportAPI.getGeneralData(baseURL: self.settings[0].url!, cardID: self.settings[0].card!))) { result in
            switch result {
            case .success(let resp):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                var decodedData: UserGeneralDataModel
                do {
                    decodedData = try decoder.decode(UserGeneralDataModel.self, from: resp.data)
                } catch {
                    return
                }
                for item in decodedData {
                    if item.key == "user_team_name" {
                        DispatchQueue.main.async {
                            userTeamName = item.value
                        }
                        return
                    }
                }
            case .failure(_):
                return
            }
        }
    }
    
    private func getSongList() {
        provider.request(MultiTarget(RediveEstertionAPI.getAllSongData)) { result in
            switch result {
            case let .success(resp):
                guard var temp = String(data: resp.data, encoding: .utf8) else { return }
                let jsonStart = temp.index(temp.startIndex, offsetBy: 16)
                temp = String(temp[jsonStart...])
                let decoder = JSONDecoder()
                var rawJson: SongInfoModelRaw
                do {
                    rawJson = try decoder.decode(SongInfoModelRaw.self, from: temp.data(using: .utf8)!)
                } catch {
                    return
                }
                var middleWare = [String : [String : Any]]()
                for item in rawJson {
                    let key = item.key
                    var songName, artist: String
                    var constant: [Int]
                    switch item.value[0] {
                    case let .string(str):
                        songName = str
                    case .integerArray(_):
                        continue
                    }
                    switch item.value[1] {
                    case let .string(str):
                        artist = str
                    case .integerArray(_):
                        continue
                    }
                    switch item.value[2] {
                    case let .integerArray(arr):
                        constant = arr
                    case .string(_):
                        continue
                    }
                    middleWare.updateValue([
                        "songName": songName,
                        "artist": artist,
                        "constant": constant
                    ], forKey: key)
                }
                let serialized = try! JSONSerialization.data(withJSONObject: middleWare)
                DispatchQueue.main.async {
                    settings[0].songList = serialized
                    persistenceController.save()
                }
            case .failure(_):
                return
            }
        }
    }
    
    private func convertRating(_ rawRT: String) -> Double {
        //Rating should be XXXX in String, convert it to XX.XX in float
        let rating = Double(rawRT)!
        return rating / 100
    }
    
    private func getColorByRating(_ rating: Int) -> Color {
        switch rating {
        case 0..<400: // GREEN
            return .green
        case 400..<700: // ORANGE
            return .orange
        case 700..<1000: // RED
            return .red
        case 1000..<1200: // PURPLE
            return .purple
        case 1200..<1300: // COPPER
            return Color(red: 217/255, green: 111/255, blue: 46/255)
        case 1300..<1400: // SILVER
            return Color(red: 92/255, green: 198/255, blue: 255/255)
        case 1400..<1450: // GOLD
            return .orange
        case 1450..<1500: // PLATINUM
            return .yellow
        default:
            return .black
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
