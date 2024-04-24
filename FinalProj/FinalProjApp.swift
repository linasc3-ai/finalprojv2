//
//  FinalProjApp.swift
//  FinalProj
//
//  Created by Lina Chihoub on 4/21/24.
//

import SwiftUI

@main
struct FinalProjApp: App {
    @StateObject var viewmodel = ExerciseViewModel()
    @StateObject var viewmodelEmotions = EmotionViewModel()
    
    var body: some Scene {
        WindowGroup {
            ExerciseView()
                .environmentObject(viewmodel).environmentObject(viewmodelEmotions)
        }
    }
}
