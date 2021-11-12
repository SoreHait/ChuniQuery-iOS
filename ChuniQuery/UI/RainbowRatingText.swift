//
//  RainbowRatingText.swift
//  ChuniQuery
//
//  Created by SoreHait on 2021/11/11.
//

import SwiftUI

struct RainbowRatingText: ViewModifier {
    func body(content: Content) -> some View {
        content.overlay(GeometryReader { (proxy: GeometryProxy) in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        [255, 0, 0],
                        [250, 144, 126],
                        [249, 249, 72],
                        [132, 252, 74],
                        [92, 250, 255],
                        [0, 0, 255]
                    ].map {
                        Color(red: $0[0]/255, green: $0[1]/255, blue: $0[2]/255)
                    }),
                    startPoint: .top,
                    endPoint: .bottom
                )
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.height
                    )
            }
        })
            .mask(content)
    }
}

struct RainbowRatingText_Previews: PreviewProvider {
    static var previews: some View {
        Text("16.00")
            .font(.title)
            .fontWeight(.bold)
            .modifier(RainbowRatingText())
        Rectangle()
            .modifier(RainbowRatingText())
    }
}
