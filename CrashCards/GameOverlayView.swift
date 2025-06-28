//
//  GameOverlayView.swift
//  CrashCards
//
//  Created by Eliza Vornia on 28/06/25.
//

import SwiftUI

struct GameOverlayView: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .foregroundColor(color)
            Button(title == "You Win!" ? "Play Again" : "Try Again") {
                action()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
