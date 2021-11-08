//
//  SongCard.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

struct SongCardJudge: View {
    var number: Int
    var body: some View {
        Section {
            VStack {
                HStack {
                    Text("TiamaT: F Minor")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Text("No.\(number)")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                HStack {
                    Text("MASTER")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 8.0)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.purple)
                        )
                    Text("SSS")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 8.0)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.orange)
                        )
                    Spacer()
                }
                HStack(alignment: .top) {
                    VStack {
                        HStack {
                            Text("分数")
                                .fontWeight(.medium)
                            Spacer()
                            Text("1010000")
                        }
                        HStack {
                            Text("定数")
                                .fontWeight(.medium)
                            Spacer()
                            Text("114.514")
                        }
                        HStack {
                            Text("Rating")
                                .fontWeight(.medium)
                            Spacer()
                            Text("1919.810")
                        }
                        HStack(alignment: .top) {
                            Text("游玩时间")
                                .fontWeight(.medium)
                            Spacer()
                            Text("2077-12-31\n23:59:59")
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
                            Text("2003")
                            Text("30")
                            Text("2")
                            Text("0")
                        }
                        .padding(.leading, 10.0)
                    }
                }
                .padding(.top, 1.0)
            }
        }
        .frame(height: 185)
    }
}

struct SongCardNoJudge: View {
    var body: some View {
        Text("Hello T2!")
    }
}

struct SongCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SongCardJudge(number: 1)
            SongCardNoJudge()
        }
    }
}
