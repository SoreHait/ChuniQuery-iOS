//
//  ChangeCardIDView.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

struct ChangeCardIDView: View {
    @State var cardID: String = "!!"
    var body: some View {
        List {
            Section(footer: Text("")) {
                TextField("卡号", text: $cardID)
            }
        }
        .navigationTitle("修改卡号")
    }
}

struct ChangeCardIDView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeCardIDView()
    }
}
