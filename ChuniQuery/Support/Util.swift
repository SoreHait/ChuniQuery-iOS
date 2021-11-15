//
//  Util.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/12.
//

import SwiftUI
import Foundation

func convertRating(_ rawRT: String) -> Double {
    //Rating should be XXXX in String, convert it to XX.XX in float
    let rating = Double(rawRT)!
    return rating / 100
}

func calcRating(score: Int, constant: Double) -> Double {
    switch score {
    case ..<800000:
        return 0.0
    case 800000..<900000:
        return (constant - 5) / 2 + ((constant - 5) - (constant - 5) / 2) * (Double(score) - 800000) / 100000
    case 900000..<925000:
        return constant - 5 + 2 * (Double(score) - 900000) / 25000
    case 925000..<975000:
        return constant - 3 + 3 * (Double(score) - 925000) / 50000
    case 975000..<1000000:
        return constant + 1 * (Double(score) - 975000) / 25000
    case 1000000..<1005000:
        return constant + 1 + 0.5 * (Double(score) - 1000000) / 5000
    case 1005000..<1007500:
        return constant + 1.5 + 0.5 * (Double(score) - 1005000) / 2500
    case 1007500...:
        return constant + 2
    default:
        return 0.0
    }
}

func getColorByRating(_ rating: Int) -> Color {
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
