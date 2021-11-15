//
//  ChangeTeamView.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI
import Moya

struct ChangeTeamView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @FetchRequest(
        sortDescriptors: []
    ) private var settings: FetchedResults<Settings>
    
    @Binding var teamName: String
    @State private var localTeamName: String = ""
    
    @State private var isNameValidate: Bool = true
    
    private let provider = MoyaProvider<MinimeSupportAPI>()
    
    var body: some View {
        Form {
            Section(footer: Text("\(localTeamName.count)/20").foregroundColor(isNameValidate ? .gray : .red)) {
                TextField("队伍名", text: $localTeamName)
                    .onChange(of: localTeamName) { _ in
                        checkName()
                    }
                    .disableAutocorrection(true)
            }
            .onAppear {
                localTeamName = teamName
            }
        }
        .navigationTitle("修改队伍名")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    modName()
                    teamName = localTeamName
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
        isNameValidate = localTeamName.count != 0
        if localTeamName.count > 20 {
            localTeamName = String(localTeamName.prefix(20))
        }
    }
    
    private func modName() {
        provider.request(.modTeamName(baseURL: settings[0].url!, cardID: settings[0].card!, teamName: localTeamName)) { _ in }
    }}
