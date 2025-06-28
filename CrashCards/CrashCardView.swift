//
//  ContentView.swift
//  CrashCards
//
//  Created by Eliza Vornia on 26/05/25.
//
import SwiftUI

struct CrashCardView: View {
    @StateObject private var viewModel = CrashCardViewModel()
    private let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        ZStack {
            Image("background-plain")
                .resizable()
                .ignoresSafeArea()

             HStack {
                 ScoreView(score: viewModel.score)
                 Spacer()
                 LivesView(lives: viewModel.lives)
             }
             .padding(.horizontal)
             .position(x: screenWidth / 2, y: 30)
//            .padding(.horizontal)
//            .position(x: screenWidth / 2, y: 30)
//            
            ForEach(viewModel.cards) { card in
                Image(card.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 90)
                    .position(x: card.xPosition, y: card.yPosition)
                    .onTapGesture { viewModel.handleTap(on: card) }
                    .animation(.linear(duration: 0.03), value: card.yPosition)
            }

            if viewModel.showBoom {
                Image("boom")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .position(viewModel.boomPosition)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.showBoom)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            withAnimation { viewModel.showBoom = false }
                        }
                    }
            }

            if viewModel.gameOver {
                GameOverlayView(title: "Game Over!", color: .white) {
                    viewModel.restartGame()
                }
            } else if viewModel.gameWin {
                GameOverlayView(title: "You Win!", color: .green) {
                    viewModel.restartGame()
                }
            }
        }
    }
}

#Preview {
    CrashCardView()
}
