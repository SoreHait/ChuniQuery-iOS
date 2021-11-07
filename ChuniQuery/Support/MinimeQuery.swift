//
//  MinimeQuery.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import Foundation
import SwiftyJSON
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
    static func getPlayerInfo(cardID: String) -> JSON? {
        let queryer = MoyaProvider<MinimeSupportAPI>()
        var retJson: JSON?
        queryer.request(.getPlayerInfo(cardID: cardID)) { result in
            switch result {
            case let .success(resp):
                do {
                    retJson = try JSON(data: resp.data)
                } catch {
                    retJson = nil
                }
                
            case .failure(_):
                retJson = nil
            }
        }
        return retJson
    }
}
