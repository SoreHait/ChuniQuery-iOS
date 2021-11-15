//
//  RecentPlayView.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

struct RecentPlayView: View {
    
    var playLog: GameplayRecordModel?
    
    var body: some View {
        List {
            ForEach(0..<playLog!.count) { num in
                let song = playLog![num]
                SongCardJudge(songName: song.songName, number: num + 1, diffID: song.level, score: song.score, constant: song.constant, rating: song.rating, playTime: song.playDate!, JCcount: song.judge![0], JCount: song.judge![1], ACount: song.judge![2], MCount: song.judge![3])
            }
        }
        .navigationTitle("最近游玩记录")
        .navigationBarTitleDisplayMode(.inline)
    }
}
