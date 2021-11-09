//
//  MinimeQuery.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import Foundation
import Moya

enum MinimeSupportAPI {
    case getPlayerInfo(cardID: String)
    case getMusicInfo(cardID: String)
    case getPlayLog(cardID: String)
    case getGeneralData(cardID: String)
    case getItems(cardID: String)
    case modItems(cardID: String, itemID: String, itemCount: String)
    case modName(cardID: String, userName: String)
    case modTeamName(cardID: String, teamName: String)
}

extension MinimeSupportAPI: TargetType {
    var baseURL: URL {
        URL(string: "http://123.57.246.220:3000")!
    }
    var path: String {
        switch self {
        case .getPlayerInfo(_), .getMusicInfo(_), .getPlayLog(_), .getGeneralData(_):
            return "/query"
        
        case .getItems(_), .modItems(_, _, _):
            return "/items"
            
        case .modName(_, _), .modTeamName(_, _):
            return "/userInfo"
        }
    }
    var method: Moya.Method {
        .get
    }
    var task: Task {
        switch self {
        case let .getPlayerInfo(cardID):
            return .requestParameters(
                parameters: [
                    "table": "cm_user_data",
                    "card": cardID
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .getMusicInfo(cardID):
            return .requestParameters(
                parameters: [
                    "table": "cm_user_music",
                    "card": cardID
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .getPlayLog(cardID):
            return .requestParameters(
                parameters: [
                    "table": "cm_user_playlog",
                    "card": cardID
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .getGeneralData(cardID):
            return .requestParameters(
                parameters: [
                    "table": "cm_user_general_data",
                    "card": cardID
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .getItems(cardID):
            return .requestParameters(
                parameters: [
                    "action": "fetch",
                    "card": cardID
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .modItems(cardID, itemID, itemCount):
            return .requestParameters(
                parameters: [
                    "action": "modify",
                    "card": cardID,
                    "item_id": itemID,
                    "item_count": itemCount
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .modName(cardID, userName):
            return .requestParameters(
                parameters: [
                    "card": cardID,
                    "user_name": userName
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .modTeamName(cardID, teamName):
            return .requestParameters(
                parameters: [
                    "card": cardID,
                    "team_name": teamName
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
    var headers: [String : String]? {
        ["User-Agent": "ChuniQuery-iOS"]
    }
}

enum RediveEstertionAPI {
    case getAllSongData
}

extension RediveEstertionAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://redive.estertion.win")!
    }
    var path: String {
        "/chuni-probe/music-constants.js"
    }
    var method: Moya.Method {
        .get
    }
    var task: Task {
        .requestPlain
    }
    var headers: [String : String]? {
        ["User-Agent": "ChuniQuery-iOS"]
    }
}

struct MinimeQuery {
    static func getPlayerInfo(cardID: String) -> UserDataModel? {
        let queryer = MoyaProvider<MinimeSupportAPI>()
        var retJson: UserDataModel?
        queryer.request(.getPlayerInfo(cardID: cardID)) { result in
            switch result {
            case let .success(resp):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                retJson = try? decoder.decode(UserDataModel.self, from: resp.data)
            case let .failure(err):
                retJson = nil
                print(err)
            }
        }
        return retJson
    }
    
    static func getMusicInfo(cardID: String) -> UserMusicModel? {
        let queryer = MoyaProvider<MinimeSupportAPI>()
        var retJson: UserMusicModel?
        queryer.request(.getMusicInfo(cardID: cardID)) { result in
            switch result {
            case let .success(resp):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                retJson = try? decoder.decode(UserMusicModel.self, from: resp.data)
            case let .failure(err):
                retJson = nil
                print(err)
            }
        }
        return retJson
    }
    
    static func getPlayLog(cardID: String) -> UserPlaylogModel? {
        let queryer = MoyaProvider<MinimeSupportAPI>()
        var retJson: UserPlaylogModel?
        queryer.request(.getPlayLog(cardID: cardID)) { result in
            switch result {
            case let .success(resp):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                retJson = try? decoder.decode(UserPlaylogModel.self, from: resp.data)
            case let .failure(err):
                retJson = nil
                print(err)
            }
        }
        return retJson
    }
    
    static func getGeneralData(cardID: String) -> UserGeneralDataModel? {
        let queryer = MoyaProvider<MinimeSupportAPI>()
        var retJson: UserGeneralDataModel?
        queryer.request(.getGeneralData(cardID: cardID)) { result in
            switch result {
            case let .success(resp):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                retJson = try? decoder.decode(UserGeneralDataModel.self, from: resp.data)
            case let .failure(err):
                retJson = nil
                print(err)
            }
        }
        return retJson
    }
    
    static func getItems(cardID: String) -> UserItemsModel? {
        let queryer = MoyaProvider<MinimeSupportAPI>()
        var retJson: UserItemsModel?
        queryer.request(.getItems(cardID: cardID)) { result in
            switch result {
            case let .success(resp):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                retJson = try? decoder.decode(UserItemsModel.self, from: resp.data)
            case let .failure(err):
                retJson = nil
                print(err)
            }
        }
        return retJson
    }
    
    static func modItems(cardID: String, itemID: String, itemCount: String) -> ModifyResultModel? {
        let queryer = MoyaProvider<MinimeSupportAPI>()
        var retJson: ModifyResultModel?
        queryer.request(.modItems(cardID: cardID, itemID: itemID, itemCount: itemCount)) { result in
            switch result {
            case let .success(resp):
                let decoder = JSONDecoder()
                retJson = try? decoder.decode(ModifyResultModel.self, from: resp.data)
            case let .failure(err):
                retJson = nil
                print(err)
            }
        }
        return retJson
    }
    
    static func modName(cardID: String, userName: String) -> ModifyResultModel? {
        let queryer = MoyaProvider<MinimeSupportAPI>()
        var retJson: ModifyResultModel?
        queryer.request(.modName(cardID: cardID, userName: userName)) { result in
            switch result {
            case let .success(resp):
                let decoder = JSONDecoder()
                retJson = try? decoder.decode(ModifyResultModel.self, from: resp.data)
            case let .failure(err):
                retJson = nil
                print(err)
            }
        }
        return retJson
    }
    
    static func modTeamName(cardID: String, teamName: String) -> ModifyResultModel? {
        let queryer = MoyaProvider<MinimeSupportAPI>()
        var retJson: ModifyResultModel?
        queryer.request(.modTeamName(cardID: cardID, teamName: teamName)) { result in
            switch result {
            case let .success(resp):
                let decoder = JSONDecoder()
                retJson = try? decoder.decode(ModifyResultModel.self, from: resp.data)
            case let .failure(err):
                retJson = nil
                print(err)
            }
        }
        return retJson
    }
    
    static func getAllSongData() -> SongInfoModel? {
        let queryer = MoyaProvider<RediveEstertionAPI>()
        var rawJson: SongInfoModelRaw?
        var retJson: SongInfoModel?
        queryer.request(.getAllSongData) { result in
            switch result {
            case let .success(resp):
                var temp = String(data: resp.data, encoding: .utf8)!
                let jsonStart = temp.index(temp.startIndex, offsetBy: 16)
                temp = String(temp[jsonStart...])
                let decoder = JSONDecoder()
                rawJson = try? decoder.decode(SongInfoModelRaw.self, from: temp.data(using: .utf8)!)
                if rawJson != nil {
                    var middleWare = [String : [String : Any]]()
                    for item in rawJson! {
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
                    retJson = try! JSONDecoder().decode(SongInfoModel.self, from: serialized)
                }
                else {
                    retJson = nil
                }
            case let .failure(err):
                retJson = nil
                print(err)
            }
        }
        return retJson
    }
}
