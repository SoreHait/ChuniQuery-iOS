//
//  JSONModel.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/8.
//

import Foundation

struct UserDataElements: Codable {
    let id, playerId, accessCode, userName, isWebJoin, webLimitDate, level, reincarnationNum, exp, point, totalPoint, playCount, multiPlayCount, multiWinCount, requestResCount, acceptResCount, successResCount, playerRating, highestRating, nameplateId, frameId, characterId, trophyId, playedTutorialBit, firstTutorialCancelNum, masterTutorialCancelNum, totalRepertoireCount, totalMapNum, totalHiScore, totalBasicHighScore, totalAdvancedHighScore, totalExpertHighScore, totalMasterHighScore, eventWatchedDate, friendCount, isMaimai, firstGameId, firstRomVersion, firstDataVersion, firstPlayDate, lastGameId, lastRomVersion, lastDataVersion, lastPlayDate, lastPlaceId, lastPlaceName, lastRegionId, lastRegionName, lastAllNetId, lastClientId: String
}
typealias UserDataModel = [UserDataElements]

struct UserMusicElements: Codable {
    let id, profileId, musicId, level, playCount, scoreMax, resRequestCount, resAcceptCount, resSuccessCount, missCount, maxComboCount, isFullCombo, isAllJustice, isSuccess, fullChain, maxChain, scoreRank, isLock: String
}
typealias UserMusicModel = [UserMusicElements]

struct UserPlaylogElements: Codable {
    let id, profileId, orderId, sortNumber, placeId, playDate, userPlayDate, musicId, level, customId, playedUserId1, playedUserId2, playedUserId3, playedUserName1, playedUserName2, playedUserName3, playedMusicLevel1, playedMusicLevel2, playedMusicLevel3, playedCustom1, playedCustom2, playedCustom3, track, score, rank, maxCombo, maxChain, rateTap, rateHold, rateSlide, rateAir, rateFlick, judgeGuilty, judgeAttack, judgeJustice, judgeCritical, eventId, playerRating, isNewRecord, isFullCombo, fullChainKind, isAllJustice, isContinue, isFreeToPlay, characterId, skillId, playKind, isClear, skillLevel, skillEffect, placeName, isMaimai: String
}
typealias UserPlaylogModel = [UserPlaylogElements]

struct UserGeneralDataElements: Codable {
    let id, profileId, key, value: String
}
typealias UserGeneralDataModel = [UserGeneralDataElements]

struct UserItemsElements: Codable {
    let id, profileId, itemKind, itemId, stock, isValid: String
}
typealias UserItemsModel = [UserItemsElements]

struct ModifyResultModel: Codable {
    let code, msg: String
}

public class SongInfoElements: NSObject, NSSecureCoding, Codable {
    let songName, artist: String
    let constant: [Int]

    public static var supportsSecureCoding: Bool {
        return true
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(songName, forKey: "songName")
        coder.encode(artist, forKey: "artist")
        coder.encode(constant, forKey: "constant")
    }
    
    public required init?(coder: NSCoder) {
        songName = coder.decodeObject(of: NSString.self, forKey: "songName")! as String
        artist = coder.decodeObject(of: NSString.self, forKey: "artist")! as String
        constant = coder.decodeObject(of: NSArray.self, forKey: "constant") as! [Int]
    }

    required public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        songName = try container.decode(String.self)
        artist = try container.decode(String.self)
        constant = try container.decode([Int].self)
        return
    }
}
public typealias SongInfoModel = [String: SongInfoElements]

struct GameplayRecordElement {
    let songName: String
    let level: Int
    let score: Int
    let constant: Double
    let rating: Double
    let playDate: Date?
    let judge: [Int]?
}
typealias GameplayRecordModel = [GameplayRecordElement]
