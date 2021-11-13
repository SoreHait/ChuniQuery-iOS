//
//  ModTicketCountView.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

fileprivate struct ModifySheet: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var text: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("数量", text: $text)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("完成")
                            .fontWeight(.bold)
                    }
                    .disabled(false)
                }
            }
            .navigationTitle("修改数量")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

fileprivate struct TicketItem: View {
    var imageItem: String
    
    @State private var isItemTapped: Bool = false
    
    var body: some View {
        Section {
            HStack {
                Section {
                    Image(imageItem)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 70.0)
                Text("Description")
                Spacer()
                Text("30")
                    .foregroundColor(.gray)
            }
        }
        .contentShape(Rectangle())
        .frame(height: 50)
        .onTapGesture { isItemTapped.toggle() }
        .sheet(isPresented: $isItemTapped) {
            ModifySheet()
        }
    }
}

struct ModTicketCountView: View {
    var body: some View {
        List {
            TicketItem(imageItem: "4x_map")
            TicketItem(imageItem: "gold_penguin")
        }
        .navigationTitle("修改道具数量")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ModTicketCountView_Previews: PreviewProvider {
    static var previews: some View {
        ModTicketCountView()
    }
}
