//
//  PlayerDataView.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

struct PlayerDataView: View {
    @FetchRequest(
        sortDescriptors: []
    ) private var settings: FetchedResults<Settings>
    
    @State var userName: String
    @State var userTeamName: String
    
    @Binding var userCurrentRating: String?
    @Binding var userHiRating: String?
    @Binding var userLevel: String?
    @Binding var playCount: String?
    @Binding var firstPlayTime: Date?
    @Binding var lastPlayTime: Date?
    
    private var dateFormatter: DateFormatter {
        let tmp = DateFormatter()
        tmp.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return tmp
    }
    
    var body: some View {
        List {
            Section(header: Text("修改资料")) {
                NavigationLink(destination: ChangeNameView(userName: $userName)) {
                    HStack {
                        Text("用户名")
                        Spacer()
                        Text(userName)
                            .foregroundColor(Color.gray)
                    }
                }
                NavigationLink(destination: ChangeTeamView(teamName: $userTeamName)) {
                    HStack {
                        Text("队伍名")
                        Spacer()
                        Text(userTeamName)
                            .foregroundColor(Color.gray)
                    }
                }
            }
            
            Section {
                HStack {
                    Text("当前Rating")
                    Spacer()
                    Text(userCurrentRating == nil ? "" : String(format: "%.2f", convertRating(userCurrentRating!)))
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("最高Rating")
                    Spacer()
                    Text(userHiRating == nil ? "" : String(format: "%.2f", convertRating(userHiRating!)))
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("等级")
                    Spacer()
                    Text(userLevel == nil ? "" : "Lv.\(userLevel!)")
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("总游玩次数")
                    Spacer()
                    Text(playCount ?? "")
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("首次游玩时间")
                    Spacer()
                    Text(firstPlayTime == nil ? "" : dateFormatter.string(from: firstPlayTime!))
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("最近游玩时间")
                    Spacer()
                    Text(lastPlayTime == nil ? "" : dateFormatter.string(from: lastPlayTime!))
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("卡号")
                    Spacer()
                    Text(settings[0].card!)
                        .foregroundColor(Color.gray)
                        .font(.custom("Menlo", size: 16))
                }
            }
        }
        .navigationTitle("个人资料")
        .navigationBarTitleDisplayMode(.inline)
    }
}
