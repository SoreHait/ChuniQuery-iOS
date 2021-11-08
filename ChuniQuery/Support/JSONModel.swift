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

enum SongInfoElementRaw: Codable {
    case integerArray([Int])
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([Int].self) {
            self = .integerArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(SongInfoElementRaw.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for SongConstantModelElement"))
    }
}
typealias SongInfoModelRaw = [String: [SongInfoElementRaw]]

struct SongInfoElements: Codable {
    let artist: String
    let songName: String
    let constant: [Int]
}
typealias SongInfoModel = [String: SongInfoElements]
