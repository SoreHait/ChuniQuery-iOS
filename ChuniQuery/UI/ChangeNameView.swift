//
//  ChangeNameView.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI
import Moya

struct ChangeNameView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @FetchRequest(
        sortDescriptors: []
    ) private var settings: FetchedResults<Settings>
    
    @Binding var userName: String
    @State private var localUserName: String = ""
    
    @State private var isNameValidate: Bool = true
    
    private let provider = MoyaProvider<MinimeSupportAPI>()
    
    var body: some View {
        Form {
            Section(footer: Text("\(localUserName.count)/8").foregroundColor(isNameValidate ? .gray : .red)) {
                TextField("玩家名", text: $localUserName)
                    .onChange(of: localUserName) { _ in
                        checkName()
                    }
                    .disableAutocorrection(true)
            }
            .onAppear {
                localUserName = userName
            }
        }
        .navigationTitle("修改玩家名")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    modName()
                    userName = localUserName
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("完成")
                        .fontWeight(.bold)
                }
                .disabled(!isNameValidate)
            }
        }
    }
    
    private func checkName() {
        isNameValidate = localUserName.count != 0
        if localUserName.count > 8 {
            localUserName = String(localUserName.prefix(8))
        }
    }
    
    private func modName() {
        provider.request(.modName(baseURL: settings[0].url!, cardID: settings[0].card!, userName: localUserName)) { _ in }
    }
}
