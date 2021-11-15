//
//  B30View.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

struct B30View: View {
    
    var b30Song: GameplayRecordModel?
    var b30RT: Double?
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Rating")
                    Spacer()
                    Text(b30RT == nil ? "" : String(format: "%.2f", b30RT!))
                        .foregroundColor(.gray)
                }
            }
            ForEach(1..<31) { num in
                let song = b30Song![num - 1]
                SongCardNoJudge(songName: song.songName, number: num, diffID: song.level, score: song.score, constant: song.constant, rating: song.rating)
            }
        }
        .navigationTitle("Best 30")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct B30View_Previews: PreviewProvider {
    static var previews: some View {
        B30View()
    }
}
