//
//  ContentView.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/6.
//

import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
/*
    @FetchRequest(
        sortDescriptors: []
    ) private var items: FetchedResults<PersistentData>
*/
    @State private var playerInfo = [UserDataElements]()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: PlayerDataView()) {
                        VStack {
                            HStack {
                                Text("?")
                                Spacer()
                                Text("??")
                            }
                            HStack {
                                Text("??")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Spacer()
                                Text("Rating")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding([.top, .leading, .bottom])
                    }
                }
                
                Section(header: Text("RATING分析")) {
                    NavigationLink(destination: B30View()) {
                        HStack {
                            Text("Best 30")
                            Spacer()
                            Text("B30 Rating")
                                .foregroundColor(Color.gray)
                        }
                    }
                    NavigationLink(destination: R10View()) {
                        HStack {
                            Text("Recent 10")
                            Spacer()
                            Text("R10 Rating")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: RecentPlayView()) {
                        Text("最近游玩记录")
                    }
                    NavigationLink(destination: ModTicketCountView()) {
                        Text("道具数量修改")
                    }
                }
                
                Section(header: Text("设定")) {
                    NavigationLink(destination: ChangeCardIDView()) {
                        Text("修改卡号")
                        Spacer()
                        Text("Current ID")
                            .foregroundColor(Color.gray)
                    }
                    NavigationLink(destination: ChangeServerView()) {
                        Text("修改服务器")
                        Spacer()
                        Text("Current Svr")
                            .foregroundColor(Color.gray)
                    }
                }
                Section(footer: Text("请不要频繁使用此功能，以免对服务器造成压力")) {
                    Button(action: {}) {
                        Text("刷新曲目数据")
                    }
                }
            }
            .navigationTitle("ChuniQuery")
            //.onAppear(perform: getInfo)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
