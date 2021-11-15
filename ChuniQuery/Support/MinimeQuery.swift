//
//  MinimeQuery.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import Foundation
import Moya

enum MinimeSupportAPI {
    case getUserData(baseURL: String, cardID: String)
    case getMusicInfo(baseURL: String, cardID: String)
    case getPlayLog(baseURL: String, cardID: String)
    case getGeneralData(baseURL: String, cardID: String)
    case getItems(baseURL: String, cardID: String)
    case modItems(baseURL: String, cardID: String, itemID: String, itemCount: String)
    case modName(baseURL: String, cardID: String, userName: String)
    case modTeamName(baseURL: String, cardID: String, teamName: String)
}

extension MinimeSupportAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .getUserData(let base, _), .getMusicInfo(let base, _), .getPlayLog(let base, _), .getGeneralData(let base, _), .getItems(let base, _), .modItems(let base, _, _, _), .modName(let base, _, _), .modTeamName(let base, _, _):
            return URL(string: base)!
        }
    }
    var path: String {
        switch self {
        case .getUserData(_, _), .getMusicInfo(_, _), .getPlayLog(_, _), .getGeneralData(_, _):
            return "/query"
        
        case .getItems(_, _), .modItems(_, _, _, _):
            return "/items"
            
        case .modName(_, _, _), .modTeamName(_, _, _):
            return "/userInfo"
        }
    }
    var method: Moya.Method {
        .get
    }
    var task: Task {
        switch self {
        case let .getUserData(_, cardID):
            return .requestParameters(
                parameters: [
                    "table": "cm_user_data",
                    "card": cardID
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .getMusicInfo(_, cardID):
            return .requestParameters(
                parameters: [
                    "table": "cm_user_music",
                    "card": cardID
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .getPlayLog(_, cardID):
            return .requestParameters(
                parameters: [
                    "table": "cm_user_playlog",
                    "card": cardID
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .getGeneralData(_, cardID):
            return .requestParameters(
                parameters: [
                    "table": "cm_user_general_data",
                    "card": cardID
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .getItems(_, cardID):
            return .requestParameters(
                parameters: [
                    "action": "fetch",
                    "card": cardID
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .modItems(_, cardID, itemID, itemCount):
            return .requestParameters(
                parameters: [
                    "action": "modify",
                    "card": cardID,
                    "item_id": itemID,
                    "item_count": itemCount
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .modName(_, cardID, userName):
            return .requestParameters(
                parameters: [
                    "card": cardID,
                    "user_name": userName
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .modTeamName(_, cardID, teamName):
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
