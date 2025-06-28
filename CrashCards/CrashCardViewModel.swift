//
//  CrashCardViewModel.swift
//  CrashCards
//
//  Created by Eliza Vornia on 28/06/25.
//
import Foundation
import SwiftUI
import CoreHaptics

class CrashCardViewModel: ObservableObject {
    @Published var cards: [CrashCardModel] = []
    @Published var gameOver = false
    @Published var gameWin = false
    @Published var lives = 3
    @Published var showBoom = false
    @Published var boomPosition: CGPoint = .zero
    @Published var score = 0

    private var spawnTimer: Timer?
    private var fallTimer: Timer?
    private var speedTimer: Timer?
    private var engine: CHHapticEngine?

    private let maxCards = 100
    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width
    private let cardImages = ["card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9", "card10","card11", "card12","card13","card14", "back"]

    private var fallSpeed: CGFloat = 3
    private var totalCards = 0

    init() {
        prepareHaptics()
        startGame()
    }

    func updateScore(by points: Int) {
        score += points
        if score < 0 { score = 0 }
    }

    func handleTap(on card: CrashCardModel) {
        if card.isTrapCard {
            boomPosition = CGPoint(x: card.xPosition, y: card.yPosition)
            withAnimation { showBoom = true }
            playExplosionHaptic()
            decreaseLife()
        }
        updateScore(by: 10) // setiap kartu yang ditap bernilai 10 poin
        cards.removeAll { $0.id == card.id }
    }

    func startGame() {
        fallSpeed = 3
        totalCards = 0
        lives = 3
        gameOver = false
        gameWin = false
        score = 0
        cards = []

        spawnTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            guard self.totalCards < self.maxCards else {
                self.spawnTimer?.invalidate()
                return
            }
            let isTrapCard = Bool.random() && Double.random(in: 0...1) < 0.2
            let imageName = isTrapCard ? "back" : self.cardImages.filter { $0 != "back" }.randomElement() ?? "card2"
            self.cards.append(CrashCardModel(xPosition: CGFloat.random(in: 50...(self.screenWidth - 50)), imageName: imageName))
            self.totalCards += 1
        }

        fallTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
            for card in self.cards {
                if card.yPosition >= self.screenHeight - 50 {
                    if !card.isTrapCard {
                        self.decreaseLife()
                    } else {
                        self.updateScore(by: 10) // ⭐ trap card lolos dapat 10 poin
                    }
                    self.cards.removeAll { $0.id == card.id }
                    return
                }
            }
            for i in self.cards.indices {
                self.cards[i].yPosition += self.fallSpeed
            }
            if self.totalCards == self.maxCards && self.cards.isEmpty {
                self.gameWin = true
                self.stopTimers()
            }
        }

        speedTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.fallSpeed += 1.5
        }
    }

    func restartGame() {
        stopTimers()
        startGame()
    }

    private func decreaseLife() {
        lives -= 1
        if lives <= 0 {
            gameOver = true
            stopTimers()
        }
    }

    private func stopTimers() {
        spawnTimer?.invalidate()
        fallTimer?.invalidate()
        speedTimer?.invalidate()
    }

    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Error starting haptic engine: \(error.localizedDescription)")
        }
    }

    private func playExplosionHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.9)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic pattern: \(error.localizedDescription)")
        }
    }
}
