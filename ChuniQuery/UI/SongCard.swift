//
//  SongCard.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

struct SongCardType1: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SongCardType2: View {
    var body: some View {
        Text("Hello T2!")
    }
}

struct SongCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SongCardType1()
            SongCardType2()
        }
    }
}
