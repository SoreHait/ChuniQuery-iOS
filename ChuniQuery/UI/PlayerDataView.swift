//
//  PlayerDataView.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/7.
//

import SwiftUI

struct PlayerDataView: View {
    var body: some View {
        List {
            Section(header: Text("修改资料")) {
                NavigationLink(destination: ChangeNameView()) {
                    HStack {
                        Text("用户名")
                        Spacer()
                        Text("当前用户名")
                            .foregroundColor(Color.gray)
                    }
                }
                NavigationLink(destination: ChangeTeamView()) {
                    HStack {
                        Text("队伍名")
                        Spacer()
                        Text("当前队伍名")
                            .foregroundColor(Color.gray)
                    }
                }
            }
            
            Section {
                HStack {
                    Text("当前Rating")
                    Spacer()
                    Text("Current RT")
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("最高Rating")
                    Spacer()
                    Text("Best RT")
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("等级")
                    Spacer()
                    Text("Current LVL")
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("总游玩次数")
                    Spacer()
                    Text("Total PC")
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("首次游玩时间")
                    Spacer()
                    Text("1975-01-01 00:00:00")
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("最近游玩时间")
                    Spacer()
                    Text("2077-12-31 23:59:59")
                        .foregroundColor(Color.gray)
                }
                HStack {
                    Text("卡号")
                    Spacer()
                    Text("Using Card ID")
                        .foregroundColor(Color.gray)
                }
            }
        }
        .navigationTitle("个人资料")
    }
}

struct PlayerDataView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerDataView()
    }
}
