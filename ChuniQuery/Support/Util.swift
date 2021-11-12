//
//  Util.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/12.
//

import Foundation

func convertRating(_ rawRT: String) -> Double {
    //Rating should be XXXX in String, convert it to XX.XX in float
    let rating = Double(rawRT)!
    return rating / 100
}
