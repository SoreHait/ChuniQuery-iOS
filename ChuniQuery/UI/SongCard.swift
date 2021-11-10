//
//  SongCard.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

private func getRankByScore(_ score: Int) -> String {
    switch score {
    case 1009000...1010000:
        return "SSS+"
    case 1007500..<1009000:
        return "SSS"
    case 1005000..<1007500:
        return "SS+"
    case 1000000..<1005000:
        return "SS"
    case 990000..<1000000:
        return "S+"
    case 975000..<990000:
        return "S"
    case 950000..<975000:
        return "AAA"
    case 925000..<950000:
        return "AA"
    case 900000..<925000:
        return "A"
    case 800000..<900000:
        return "BBB"
    case 700000..<800000:
        return "BB"
    case 600000..<700000:
        return "B"
    case 500000..<600000:
        return "C"
    case 0..<500000:
        return "D"
    default:
        return "???"
    }
}

private func getColorByScore(_ score: Int) -> Color {
    switch score {
    case 975000...1010000:
        return .yellow
    case 900000..<975000:
        return .orange
    case 600000..<900000:
        return .teal
    case 500000..<600000:
        return .brown
    case 0..<500000:
        return .gray
    default:
        return .black
    }
}

private func getDiffByID(_ id: String) -> String {
    switch id {
    case "0":
        return "BASIC"
    case "1":
        return "ADVANCED"
    case "2":
        return "EXPERT"
    case "3":
        return "MASTER"
    default:
        return "???"
    }
}

private func getDiffColorByID(_ id: String) -> Color {
    switch id {
    case "0":
        return .green
    case "1":
        return .yellow
    case "2":
        return .red
    case "3":
        return .purple
    default:
        return .black
    }

}

struct SongCardJudge: View {
    var songName: String
    var number: Int
    var diffID: String
    var score: Int
    var constant: Double
    var rating: Double
    var playTime: String
    var JCcount: Int
    var JCount: Int
    var ACount: Int
    var MCount: Int
    
    var rank: String {
        getRankByScore(score)
    }
    
    var rankColor: Color {
        getColorByScore(score)
    }
    
    var diff: String {
        getDiffByID(diffID)
    }
    
    var diffColor: Color {
        getDiffColorByID(diffID)
    }
    
    var body: some View {
        Section {
            VStack {
                HStack {
                    Text(songName)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Text("No.\(number)")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                HStack {
                    Text(diff)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 8.0)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(diffColor)
                        )
                    Text(rank)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 8.0)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(rankColor)
                        )
                    Spacer()
                    if MCount == 0 && ACount > 0 {
                        Text("FC")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 8.0)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.green)
                            )
                    } else if MCount == 0 && ACount == 0 {
                        Text("AJ")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 8.0)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.orange)
                            )
                    }
                }
                HStack(alignment: .top) {
                    VStack {
                        HStack {
                            Text("分数")
                                .fontWeight(.medium)
                            Spacer()
                            Text(String(score))
                        }
                        HStack {
                            Text("定数")
                                .fontWeight(.medium)
                            Spacer()
                            Text("\(constant, specifier: "%.2f")")
                        }
                        HStack {
                            Text("Rating")
                                .fontWeight(.medium)
                            Spacer()
                            Text("\(rating, specifier: "%.2f")")
                        }
                        HStack(alignment: .top) {
                            Text("游玩时间")
                                .fontWeight(.medium)
                            Spacer()
                            Text(playTime)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    .frame(width: 180.0)
                    Spacer()
                    HStack(alignment: .top) {
                        VStack {
                            Text("JC")
                                .foregroundColor(.yellow)
                            Text("J")
                                .foregroundColor(.orange)
                            Text("A")
                                .foregroundColor(.green)
                            Text("M")
                                .foregroundColor(.gray)
                        }
                        VStack {
                            Text(String(JCcount))
                            Text(String(JCount))
                            Text(String(ACount))
                            Text(String(MCount))
                        }
                        .padding(.leading, 10.0)
                    }
                }
                .padding(.top, 1.0)
            }
        }
        .frame(height: 180)
    }
}

struct SongCardNoJudge: View {
    var songName: String
    var number: Int
    var diffID: String
    var score: Int
    var constant: Double
    var rating: Double
    
    var rank: String {
        getRankByScore(score)
    }
    
    var rankColor: Color {
        getColorByScore(score)
    }
    
    var diff: String {
        getDiffByID(diffID)
    }
    
    var diffColor: Color {
        getDiffColorByID(diffID)
    }
    
    var body: some View {
        Section {
            VStack {
                HStack {
                    Text(songName)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Text("No.\(number)")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                HStack {
                    Text(diff)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 8.0)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(diffColor)
                        )
                    Text(rank)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 8.0)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(rankColor)
                        )
                    Spacer()
                }
                HStack(alignment: .top) {
                    VStack {
                        HStack {
                            Text("分数")
                                .fontWeight(.medium)
                            Spacer()
                            Text(String(score))
                        }
                        HStack {
                            Text("定数")
                                .fontWeight(.medium)
                            Spacer()
                            Text("\(constant, specifier: "%.2f")")
                        }
                        HStack {
                            Text("Rating")
                                .fontWeight(.medium)
                            Spacer()
                            Text("\(rating, specifier: "%.2f")")
                        }
                    }
                    .frame(width: 180.0)
                    Spacer()
                }
                .padding(.top, 1.0)
            }
        }
        .padding(.vertical, 9.0)
    }
}


struct SongCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SongCardJudge(songName: "World Vanquisher", number: 1, diffID: "0", score: 1009750, constant: 14.90, rating: 17.90, playTime: "2077-11-11\n20:28:37", JCcount: 3499, JCount: 1, ACount: 0, MCount: 0)
            SongCardNoJudge(songName: "World Vanquisher", number: 1, diffID: "2", score: 1009750, constant: 14.90, rating: 17.90)
        }
    }
}
