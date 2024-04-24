//
//  Emotions.swift
//  FinalProj
//
//  Created by Lina Chihoub on 4/21/24.
//

import Foundation


struct Emotion: Codable {
    let id: UUID = UUID()  // Unique identifier for each emotion
    var name: String // the type of emotion, e.g. happiness
    var emoji: String // emoji representing the image for the emotion 
    var severity: Double // severity of emotion
    var reflection: String // the reflection of why you feel that way for the emotion
}
