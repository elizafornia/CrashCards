//
//  LivesView.swift
//  CrashCards
//
//  Created by Eliza Vornia on 28/06/25.
//

import SwiftUI

struct LivesView: View {
    let lives: Int
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                Image(systemName: index < lives ? "heart.fill" : "heart")
                    .foregroundColor(index < lives ? .red : .gray.opacity(0.3))
                    .font(.title3)
            }
        }
        .frame(width: 120, height: 40)
        .background(Color.white.opacity(0.85))
        .cornerRadius(20)
    }
}
