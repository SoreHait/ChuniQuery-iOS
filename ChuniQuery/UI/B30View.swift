//
//  B30View.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

struct B30View: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Rating")
                    Spacer()
                    Text("B30 Rating")
                        .foregroundColor(.gray)
                }
            }
            ForEach(1..<10) { num in
                SongCardNoJudge(songName: "World Vanquisher", number: num, diffID: String(num % 4), score: 1010000, constant: 14.90, rating: 17.90)
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
