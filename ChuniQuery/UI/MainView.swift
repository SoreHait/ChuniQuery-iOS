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
/*
    @FetchRequest(
        sortDescriptors: []
    ) private var items: FetchedResults<PersistentData>
*/
    
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
            return .brown
        case 1300..<1400: // SILVER
            return .teal
        case 1400..<1450: // GOLD
            return .orange
        case 1450..<1500: // PLATINUM
            return .yellow
        default:
            return .black
        }
    }
    
    @State private var userData: UserDataElements?
    @State private var userGeneralData: UserGeneralDataElements?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: PlayerDataView()) {
                        VStack {
                            HStack {
                                Text(userGeneralData == nil ? (userData == nil ? "" : "未设置队伍名") : userGeneralData!.value) // Team
                                Spacer()
                                Text(userData == nil ? "" : "Lv." + userData!.level) // Lv
                            }
                            HStack {
                                Text(userData == nil ? "加载中..." : userData!.userName) // Name
                                    .font(.title)
                                    .fontWeight(.bold)
                                Spacer()
                                if let userData = userData {
                                    let rating = String(format: "%.2f", convertRating(userData.playerRating))
                                    let rawRating = Int(userData.playerRating)!
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
                    NavigationLink(destination: ChangeCardIDView()) {
                        Text("修改卡号")
                        Spacer()
                        Text("Current ID") // Set CardID
                            .foregroundColor(Color.gray)
                    }
                    NavigationLink(destination: ChangeServerView()) {
                        Text("修改服务器")
                        Spacer()
                        Text("Current Svr") // Set Server Addr
                            .foregroundColor(Color.gray)
                    }
                }
                Section(footer: Text("请在曲目详细信息显示异常的情况下使用此功能")) {
                    Button(action: {}) {
                        Text("刷新曲目数据库")
                    }
                }
            }
            .navigationTitle("ChuniQuery")
            .onAppear(perform: {
                getUserData(cardID: "012E4CD68ECD855E")
                getGeneralData(cardID: "012E4CD68ECD855E")
            })
        }
    }
    
    func getUserData(cardID: String) {
        let provider = MoyaProvider<MinimeSupportAPI>()
        provider.request(.getUserData(cardID: cardID)) { result in
            switch result {
            case .success(let resp):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                DispatchQueue.main.async {
                    do {
                        userData = try decoder.decode(UserDataModel.self, from: resp.data)[0]
                    } catch {
                        userData = nil
                    }
                }
            case .failure(_):
                userData = nil
            }
        }
    }
    
    func getGeneralData(cardID: String) {
        let provider = MoyaProvider<MinimeSupportAPI>()
        provider.request(.getGeneralData(cardID: cardID)) { result in
            switch result {
            case .success(let resp):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                DispatchQueue.main.async {
                    do {
                        let decodedData = try decoder.decode(UserGeneralDataModel.self, from: resp.data)
                        for item in decodedData {
                            if item.key == "user_team_name" {
                                userGeneralData = item
                                return
                            }
                        }
                        userGeneralData = nil
                    } catch {
                        userGeneralData = nil
                    }
                }
            case .failure(_):
                userGeneralData = nil
            }
        }
    }
    
    func convertRating(_ rawRT: String) -> Double {
        //Rating should be XXXX in String, convert it to XX.XX in float
        let rating = Double(rawRT)!
        return rating / 100
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
