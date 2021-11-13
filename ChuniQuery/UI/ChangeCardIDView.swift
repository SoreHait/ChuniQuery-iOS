//
//  ChangeCardIDView.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

fileprivate struct InputHint: View {
    @Binding var cardID: String
    @Binding var isLengthMeet: Bool
    @Binding var isCharMeet: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(cardID.count)/16")
                .foregroundColor(isLengthMeet ? .gray : .red)
            Text("十六进制（只含有[0123456789ABCDEF]）")
                .foregroundColor(isCharMeet ? .gray : .red)
        }
    }
}

struct ChangeCardIDView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    @FetchRequest(
        sortDescriptors: []
    ) private var settings: FetchedResults<Settings>
    
    @State private var cardID: String = ""
    @State private var isLengthMeet: Bool = true
    @State private var isCharMeet: Bool = true
    
    private let hexPattern: NSRegularExpression = try! NSRegularExpression(pattern: "[^0-9a-fA-F]")
    private let persistenceController = PersistenceController.shared
    
    var body: some View {
        Form {
            Section(footer: InputHint(cardID: $cardID, isLengthMeet: $isLengthMeet, isCharMeet: $isCharMeet)) {
                TextField("卡号", text: $cardID)
                    .onChange(of: cardID) { _ in
                        checkCardID()
                    }
                    .disableAutocorrection(true)
                    .font(.custom("Menlo", size: 16))
            }
            .onAppear {
                cardID = settings[0].card!
                if cardID == "" {
                    isCharMeet = false
                    isLengthMeet = false
                }
            }
        }
        .navigationBarTitle("修改卡号", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    settings[0].card = cardID
                    persistenceController.save()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("完成")
                        .fontWeight(.bold)
                }
                .disabled(!(isLengthMeet && isCharMeet))
            }
        }
    }
    
    private func checkCardID() {
        cardID = cardID.uppercased()
        isLengthMeet = cardID.count == 16
        if cardID.count > 16 {
            cardID = String(cardID.prefix(16))
        }
        isCharMeet = hexPattern.firstMatch(in: cardID, options: [], range: NSRange(location: 0, length: cardID.count)) == nil
    }
}

/*
struct ChangeCardIDView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeCardIDView()
    }
}
 */
