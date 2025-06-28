//
//  ScoreView.swift
//  CrashCards
//
//  Created by Eliza Vornia on 29/06/25.
//
import SwiftUI

struct ScoreView: View {
    var score: Int
    
    var body: some View {
        Text("Score: \(score)")
            .font(.title3)
            .padding(8)
            .background(Color.white.opacity(0.85))
            .cornerRadius(20)
    }
}

#Preview {
    ScoreView(score: 120)
}
