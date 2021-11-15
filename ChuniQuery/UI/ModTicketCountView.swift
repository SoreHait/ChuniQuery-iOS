//
//  ModTicketCountView.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI
import Moya

fileprivate let provider = MoyaProvider<MinimeSupportAPI>()

fileprivate struct ModifySheet: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @FetchRequest(
        sortDescriptors: []
    ) private var settings: FetchedResults<Settings>
    
    @State private var isAmountValidate: Bool = true
    
    @Binding var amount: String
    
    var item: Items
        
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("\(amount.count)/4").foregroundColor(isAmountValidate ? .gray : .red)) {
                    TextField("数量", text: $amount)
                        .keyboardType(.numberPad)
                        .onChange(of: amount) { _ in
                            isAmountValidate = amount.count != 0
                            if amount.count > 4 {
                                amount = String(amount.prefix(4))
                            }
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        modItems()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("完成")
                            .fontWeight(.bold)
                    }
                    .disabled(!isAmountValidate)
                }
            }
            .navigationTitle("修改\(item.name)数量")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func modItems() {
        provider.request(.modItems(baseURL: settings[0].url!, cardID: settings[0].card!, itemID: item.id, itemCount: amount)) { result in }
    }
}

fileprivate struct TicketItem: View {
    var item: Items
    
    @Binding var amount: String
    @State private var isItemTapped: Bool = false
    
    var body: some View {
        Section {
            HStack {
                Section {
                    Image(item.asset)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 70.0)
                Text(item.name)
                Spacer()
                Text(amount)
                    .foregroundColor(.gray)
            }
        }
        .contentShape(Rectangle())
        .frame(height: 50)
        .onTapGesture { isItemTapped.toggle() }
        .sheet(isPresented: $isItemTapped) {
            ModifySheet(amount: $amount, item: item)
        }
    }
}

fileprivate struct Items {
    let id: String
    let name: String
    let asset: String
    
    static let goldPenguin = Items(id: "8000", name: "金企鹅", asset: "gold_penguin")
    static let chuniNetTicket = Items(id: "110", name: "Chuni-Net券", asset: "chuni_net")
    static let map4x = Items(id: "5060", name: "4倍跑图券", asset: "4x_map")
    static let song6x = Items(id: "5230", name: "6曲券", asset: "6x_track")
    static let weTicket = Items(id: "5310", name: "World's End券", asset: "world_end")
    static let song7x = Items(id: "5410", name: "7曲券", asset: "7x_track")
}

struct ModTicketCountView: View {
    @FetchRequest(
        sortDescriptors: []
    ) private var settings: FetchedResults<Settings>
    
    @State private var gpAmount = "0"
    @State private var cntAmount = "0"
    @State private var map4xAmount = "0"
    @State private var song6xAmount = "0"
    @State private var wetAmount = "0"
    @State private var song7xAmount = "0"
    
    var body: some View {
        List {
            TicketItem(item: .goldPenguin, amount: $gpAmount)
            TicketItem(item: .chuniNetTicket, amount: $cntAmount)
            TicketItem(item: .map4x, amount: $map4xAmount)
            TicketItem(item: .song6x, amount: $song6xAmount)
            TicketItem(item: .weTicket, amount: $wetAmount)
            TicketItem(item: .song7x, amount: $song7xAmount)
        }
        .navigationTitle("修改道具数量")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            getItems()
        }
    }
    
    private func getItems() {
        provider.request(.getItems(baseURL: settings[0].url!, cardID: settings[0].card!)) { result in
            switch result {
            case let .success(resp):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                var items: UserItemsModel
                do {
                    items = try decoder.decode(UserItemsModel.self, from: resp.data)
                } catch {
                    return
                }
                DispatchQueue.main.async {
                    for item in items {
                        switch item.itemId {
                        case Items.goldPenguin.id:
                            gpAmount = item.stock
                        case Items.chuniNetTicket.id:
                            cntAmount = item.stock
                        case Items.map4x.id:
                            map4xAmount = item.stock
                        case Items.song6x.id:
                            song6xAmount = item.stock
                        case Items.weTicket.id:
                            wetAmount = item.stock
                        case Items.song7x.id:
                            song7xAmount = item.stock
                        default:
                            continue
                        }
                    }
                }
            case .failure(_):
                return
            }
        }
    }
}
