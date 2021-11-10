//
//  R10View.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

struct R10View: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Rating")
                    Spacer()
                    Text("R10 Rating")
                        .foregroundColor(.gray)
                }
            }
            ForEach(1..<11) { num in
                SongCardJudge(songName: "World Vanquisher", number: num, diffID: String(num % 4), score: num == 1 ? 1010000 : (12 - num) * 100000 , constant: 14.90, rating: 17.90, playTime: "2077-11-11\n20:28:37", JCcount: 3500, JCount: num - 1, ACount: num == 1 ? num - 1 : num - 2, MCount: num <= 2 ? 0 : num - 3)
            }
        }
        .navigationTitle("Recent 10")
    }
}

struct R10View_Previews: PreviewProvider {
    static var previews: some View {
        R10View()
    }
}
