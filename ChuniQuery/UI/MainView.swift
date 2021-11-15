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
    @State private var isRecentFetched: Bool = false
    @State private var isBestFetched: Bool = false
    
    @State private var userName: String?
    @State private var userTeamName: String?
    @State private var userLevel: String?
    @State private var userCurrentRating: String?
    @State private var userHiRating: String?
    @State private var playCount: String?
    @State private var firstPlayTime: Date?
    @State private var lastPlayTime: Date?
    
    @State private var playLog: GameplayRecordModel?
    @State private var recent10: GameplayRecordModel?
    @State private var best30: GameplayRecordModel?
    @State private var recent10RT: Double?
    @State private var best30RT: Double?
    
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
                    NavigationLink(destination: B30View(b30Song: best30, b30RT: best30RT)) {
                        HStack {
                            Text("Best 30")
                            Spacer()
                            Text(best30RT == nil ? "" : String(format: "%.2f", best30RT!)) // B30 RT
                                .foregroundColor(Color.gray)
                        }
                    }
                    .disabled(!isUserDataFetched || isWrongCard || unableToFetch || isCardIDNotSet || !isBestFetched)
                    NavigationLink(destination: R10View(r10Song: recent10, r10RT: recent10RT)) {
                        HStack {
                            Text("Recent 10")
                            Spacer()
                            Text(recent10RT == nil ? "" : String(format: "%.2f", recent10RT!)) // R10 RT
                                .foregroundColor(Color.gray)
                        }
                    }
                    .disabled(!isUserDataFetched || isWrongCard || unableToFetch || isCardIDNotSet || !isRecentFetched)
                }
                
                Section {
                    NavigationLink(destination: RecentPlayView(playLog: playLog)) {
                        Text("最近游玩记录")
                    }
                    .disabled(!isUserDataFetched || isWrongCard || unableToFetch || isCardIDNotSet || !isRecentFetched)
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
        userName = nil
        userTeamName = nil
        userLevel = nil
        userCurrentRating = nil
        userHiRating = nil
        playLog = nil
        recent10 = nil
        best30 = nil
        recent10RT = nil
        best30RT = nil
        isUserDataFetched = false
        isWrongCard = false
        unableToFetch = false
        isRecentFetched = false
        isBestFetched = false
    }
    
    private func fetchData() {
        getUserData()
        getGeneralData()
        getPlayData()
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
    
    private func getPlayData() {
        let decoder = JSONDecoder()
        let songDB = try? decoder.decode(SongInfoModel.self, from: settings[0].songList ?? Data())
        var musicRecord: UserMusicModel?
        provider.request(MultiTarget(MinimeSupportAPI.getMusicInfo(baseURL: settings[0].url!, cardID: settings[0].card!))) { result in
            switch result {
            case let .success(resp):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                musicRecord = try! decoder.decode(UserMusicModel.self, from: resp.data)
                var musicLog = GameplayRecordModel()
                for record in musicRecord! {
                    var songName: String
                    var allConstant: [Int]
                    if songDB != nil && songDB![record.musicId] != nil {
                        songName = songDB![record.musicId]!.songName
                        allConstant = songDB![record.musicId]!.constant
                    }
                    else {
                        songName = "未知歌曲 #\(record.musicId)"
                        allConstant = []
                    }
                    let level = Int(record.level)!
                    var constant: Double
                    if level == 4 || allConstant.isEmpty {
                        constant = 0.0
                    }
                    else {
                        constant = Double(allConstant[level]) / 100
                    }
                    let score = Int(record.scoreMax)!
                    var rating: Double
                    if constant == 0.0 {
                        rating = 0.0
                    }
                    else {
                        rating = calcRating(score: score, constant: constant)
                    }
                    musicLog.append(GameplayRecordElement(songName: songName, level: level, score: score, constant: constant, rating: rating, playDate: nil, judge: nil))
                }
                musicLog.sort { $0.rating > $1.rating }
                DispatchQueue.main.async {
                    best30 = Array(musicLog[0..<30])
                    var best30TotalRT = 0.0
                    for item in best30! {
                        best30TotalRT += item.rating
                    }
                    best30RT = best30TotalRT / 30
                    isBestFetched = true
                }
                case .failure(_):
                    return
            }
        }
        
        var historyRecord: UserPlaylogModel?
        provider.request(MultiTarget(MinimeSupportAPI.getPlayLog(baseURL: settings[0].url!, cardID: settings[0].card!))) { result in
            switch result {
            case let .success(resp):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                historyRecord = try? decoder.decode(UserPlaylogModel.self, from: resp.data)
                var playLogTmp = GameplayRecordModel()
                for record in historyRecord! {
                    var songName: String
                    var allConstant: [Int]
                    if songDB != nil && songDB![record.musicId] != nil {
                        songName = songDB![record.musicId]!.songName
                        allConstant = songDB![record.musicId]!.constant
                    }
                    else {
                        songName = "未知歌曲 #\(record.musicId)"
                        allConstant = []
                    }
                    let level = Int(record.level)!
                    var constant: Double
                    if level == 4 || allConstant.isEmpty {
                        constant = 0.0
                    }
                    else {
                        constant = Double(allConstant[level]) / 100
                    }
                    let score = Int(record.score)!
                    var rating: Double
                    if constant == 0.0 {
                        rating = 0.0
                    }
                    else {
                        rating = calcRating(score: score, constant: constant)
                    }
                    let playDate = dateFormatter.date(from: record.userPlayDate)
                    let judge = [Int(record.judgeCritical)!, Int(record.judgeJustice)!, Int(record.judgeAttack)!, Int(record.judgeGuilty)!]
                    playLogTmp.append(GameplayRecordElement(songName: songName, level: level, score: score, constant: constant, rating: rating, playDate: playDate, judge: judge))
                }
                playLogTmp.sort { $0.playDate!.compare($1.playDate!) == .orderedDescending }
                var recentCount = 30
                var recent30 = GameplayRecordModel()
                for record in playLogTmp {
                    if record.level == 4 {
                        continue
                    }
                    recent30.append(record)
                    if record.score < 1007500 {
                        recentCount -= 1
                    }
                    if recentCount == 0 {
                        break
                    }
                }
                recent30.sort { $0.rating > $1.rating }
                DispatchQueue.main.async {
                    playLog = playLogTmp
                    recent10 = Array(recent30[0..<10])
                    var recent10TotalRT = 0.0
                    for item in recent10! {
                        recent10TotalRT += item.rating
                    }
                    recent10RT = recent10TotalRT / 10
                    isRecentFetched = true
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
}
