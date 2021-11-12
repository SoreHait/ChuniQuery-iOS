//
//  ChangeServerView.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

struct ChangeServerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    @FetchRequest(
        sortDescriptors: []
    ) private var settings: FetchedResults<Settings>
    
    @State private var serverURL: String = ""
    @State private var isURLValidate: Bool = true
    
    private let persistenceController = PersistenceController.shared
    
    var body: some View {
        Form {
            Section(footer: Text("服务器应以\"http://\"开头").foregroundColor(isURLValidate ? .gray : .red)) {
                TextField("", text: $serverURL)
                    .onChange(of: serverURL) { _ in
                        checkURL()
                    }
                    .disableAutocorrection(true)
            }
            .onAppear {
                serverURL = settings[0].url!
            }
            
            Section(header: Text("预设服务器")) {
                Button(action: { serverURL = "http://123.57.246.220:3000" }) {
                    Text("BBS")
                }
                Button(action: { serverURL = "http://chuleethm.xyz:3000" }) {
                    Text("Lee")
                }
            }
        }
        .navigationBarTitle("修改服务器", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    settings[0].url = serverURL
                    persistenceController.save()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("完成")
                        .fontWeight(.bold)
                }
                .disabled(!isURLValidate)
            }
        }
    }
    
    private func checkURL() {
        isURLValidate = serverURL.starts(with: "http://")
    }
}

struct ChangeServerView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeServerView()
    }
}
