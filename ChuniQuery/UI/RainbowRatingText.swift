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
                    gradient: Gradient(colors: stride(from: 0, to: 1, by: 0.1).map { hue in
                        Color(hue: hue, saturation: 1, brightness: 1)
                    }),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
        })
            .mask(content)
    }
}

struct RainbowRatingText_Previews: PreviewProvider {
    static var previews: some View {
        Text("15.99")
            .modifier(RainbowRatingText())
    }
}
