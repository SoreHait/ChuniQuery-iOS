//
//  R10View.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

struct R10View: View {
    
    var r10Song: GameplayRecordModel?
    var r10RT: Double?
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Rating")
                    Spacer()
                    Text(r10RT == nil ? "" : String(format: "%.2f", r10RT!))
                        .foregroundColor(.gray)
                }
            }
            ForEach(1..<11) { num in
                let song = r10Song![num - 1]
                SongCardJudge(songName: song.songName, number: num, diffID: song.level, score: song.score, constant: song.constant, rating: song.rating, playTime: song.playDate!, JCcount: song.judge![0], JCount: song.judge![1], ACount: song.judge![2], MCount: song.judge![3])
            }
        }
        .navigationTitle("Recent 10")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct R10View_Previews: PreviewProvider {
    static var previews: some View {
        R10View()
    }
}
