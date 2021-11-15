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
    private var dateFormatter: DateFormatter {
        let tmp = DateFormatter()
        tmp.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return tmp
    }
    
    @State private var isCardIDNotSet: Bool = true
    @State private var isUserDataFetched: Bool = false
    @State private var isWrongCard: Bool = false
    @State private var unableToFetch: Bool = false
    
    @State private var userName: String?
    @State private var userTeamName: String?
    @State private var userLevel: String?
    @State private var userCurrentRating: String?
    @State private var userHiRating: String?
    @State private var playCount: String?
    @State private var firstPlayTime: Date?
    @State private var lastPlayTime: Date?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: PlayerDataView(
                        userName: userName ?? "",
                        userTeamName: userTeamName ?? "",
                        userCurrentRating: $userCurrentRating,
                        userHiRating: $userHiRating,
                        userLevel: $userLevel,
                        playCount: $playCount,
                        firstPlayTime: $firstPlayTime,
                        lastPlayTime: $lastPlayTime
                    )) {
                        VStack {
                            HStack {
                                Text(unableToFetch || isWrongCard ? "" : (userTeamName ?? (isUserDataFetched ? "未设置队伍名" : ""))) // Team
                                Spacer()
                            }
                            HStack {
                                if !isCardIDNotSet {
                                    Text(unableToFetch ? "数据获取失败" : (isWrongCard ? "卡号错误/没有数据" : (userName ?? "加载中..."))) // Name
                                        .font(.title)
                                        .fontWeight(.bold)
                                } else {
                                    Text("未设置卡号")
                                        .font(.title)
                                        .fontWeight(.bold)
                                }
                                Spacer()
                            }
                            HStack {
                                Text(unableToFetch || isWrongCard ? "" : (userLevel == nil ? "" : "Lv.\(userLevel!)")) // Lv
                                Spacer()
                                Text(unableToFetch || isWrongCard ? "" : "Rating")
                                if let userRating = userCurrentRating {
                                    let rating = String(format: "%.2f", convertRating(userRating))
                                    let rawRating = Int(userRating)!
                                    if rawRating >= 1500 {
                                        Text(unableToFetch || isWrongCard ? "" : rating)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .modifier(RainbowRatingText())
                                    } else {
                                        Text(unableToFetch || isWrongCard ? "" : rating)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(getColorByRating(rawRating))
                                    }
                                }
                            }
                        }
                        .padding([.top, .leading, .bottom])
                    }
                    .disabled(!isUserDataFetched || isWrongCard || unableToFetch || isCardIDNotSet)
                }
                
                Section {
                    Button(action: {
                        if unableToFetch {
                            unableToFetch = false
                        }
                        fetchData()
                    }) {
                        Text("刷新数据")
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
                    .disabled(!isUserDataFetched || isWrongCard || unableToFetch || isCardIDNotSet)
                    NavigationLink(destination: R10View()) {
                        HStack {
                            Text("Recent 10")
                            Spacer()
                            Text("R10 Rating") // R10 RT
                                .foregroundColor(Color.gray)
                        }
                    }
                    .disabled(!isUserDataFetched || isWrongCard || unableToFetch || isCardIDNotSet)
                }
                
                Section {
                    NavigationLink(destination: RecentPlayView()) {
                        Text("最近游玩记录")
                    }
                    .disabled(!isUserDataFetched || isWrongCard || unableToFetch || isCardIDNotSet)
                    NavigationLink(destination: ModTicketCountView()) {
                        Text("修改道具数量")
                    }
                    .disabled(!isUserDataFetched || isWrongCard || unableToFetch || isCardIDNotSet)
                }
                
                Section(header: Text("设定")) {
                    NavigationLink(destination: ChangeCardIDView()
                                    .onDisappear(perform: {
                        reinit()
                        fetchData()
                    })) {
                        Text("修改卡号")
                        Spacer()
                    }
                    NavigationLink(destination: ChangeServerView()
                                    .onDisappear(perform: {
                        reinit()
                        fetchData()
                    })) {
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
            .sheet(isPresented: $isCardIDNotSet, onDismiss: {
                isCardIDNotSet = !(settings[0].card! == "" ? false : true)
                if !isCardIDNotSet {
                    fetchData()
                }
            }) {
                NavigationView {
                    ChangeCardIDView()
                }
            }
            .navigationTitle("ChuniQuery")
        }
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
            
            if !isCardIDNotSet {
                fetchData()
            }
        }
    }
    
    private func reinit() {
        userName = ""
        userTeamName = nil
        userLevel = nil
        userCurrentRating = nil
        userHiRating = nil
        isUserDataFetched = false
        isWrongCard = false
        unableToFetch = false
    }
    
    private func fetchData() {
        getUserData()
        getGeneralData()
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
                        unableToFetch = false
                    }
                    return
                }
                DispatchQueue.main.async {
                    userName = userData.userName
                    userLevel = userData.level
                    userCurrentRating = userData.playerRating
                    userHiRating = userData.highestRating
                    playCount = userData.playCount
                    firstPlayTime = dateFormatter.date(from: userData.firstPlayDate)
                    lastPlayTime = dateFormatter.date(from: userData.lastPlayDate)
                    isUserDataFetched = true
                    isWrongCard = false
                    unableToFetch = false
                }
            case .failure(_):
                DispatchQueue.main.async {
                    unableToFetch = true
                }
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
