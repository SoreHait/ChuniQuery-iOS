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
            ForEach(1..<10) {num in
                SongCardJudge(number: num)
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
