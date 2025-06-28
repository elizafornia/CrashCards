//
//  CrashCard.swift
//  CrashCards
//
//  Created by Eliza Vornia on 28/06/25.
//

import Foundation

struct CrashCardModel: Identifiable {
    let id = UUID()
    var xPosition: CGFloat
    var yPosition: CGFloat = 100
    var imageName: String
    var isTrapCard: Bool { imageName == "back" }
}
