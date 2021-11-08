//
//  ContentView.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/6.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
/*
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
*/
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: PlayerDataView()) {
                        VStack {
                            HStack {
                                Text("队伍名")
                                Spacer()
                                Text("等级")
                            }
                            HStack {
                                Text("用户名")
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
                    NavigationLink(destination: ChangeIDView()) {
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
                    Button(action: {}) {
                        Text("刷新数据")
                    }
                }
            }
            .navigationTitle("ChuniQuery")
        }
    }
/*
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
*/
}
/*
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
*/
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()//.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
