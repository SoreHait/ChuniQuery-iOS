//
//  ChangeCardIDView.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

struct ChangeCardIDView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: []
    ) private var settings: FetchedResults<Settings>
    
    @State private var cardID: String = ""
    
    var body: some View {
        Form {
            Section(footer: Text("")) {
                TextField("卡号", text: $cardID)
            }
            .onAppear {
                cardID = settings[0].card!
            }
        }
        .navigationBarTitle("修改卡号", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Text("完成")
                        .fontWeight(.bold)
                }
            }
        }
    }
}

/*
struct ChangeCardIDView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeCardIDView()
    }
}
 */
