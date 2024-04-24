//
//  EmotionScreener.swift
//  FinalProj
//
//  Created by Lina Chihoub on 4/21/24.
//

import SwiftUI

struct EmotionScreener: View {
    // int holding severity
    @State private var selectedEmotionIndex: Int = 0
    
    @StateObject var viewmodelEmotions = EmotionViewModel()
    
    // array to hold emotion objects
    @State private var emotions: [Emotion] = [
        // by default, set severity to 0 and reflction to empty string
        // we will update these parameters as we get the info
        Emotion(name: "Happiness", emoji: "😄", severity: 0.0, reflection: ""),
        Emotion(name: "Sadness", emoji: "😢",  severity: 0.0, reflection: ""),
        Emotion(name: "Anger", emoji: "😠",  severity: 0.0, reflection: ""),
        Emotion(name: "Fear", emoji: "😨",  severity: 0.0, reflection: ""),
        Emotion(name: "Disgust", emoji: "🤢",  severity: 0.0, reflection: ""),
        Emotion(name: "Surprise", emoji: "😲",  severity: 0.0, reflection: ""),
        Emotion(name: "Love", emoji: "😍",  severity: 0.0, reflection: "")
        ]
    
    var body: some View {
        NavigationView {
            
            // emotion selection section
            // you pick an emotion and the emotion you pick's index will be stored in selectedEmotionIndex
            // for each value in emotions array, display the emoji and its name
            // form will group the UI elements logically .. will group based on sections
            Form {
                Section(header: Text("Emotion Survey").font(.largeTitle)) {
                    Text("How are you feeling after your workout?")
                    Picker("Select an Emotion", selection: $selectedEmotionIndex) {
                        ForEach(emotions.indices, id: \.self) { index in
                            Text(emotions[index].emoji + " " + emotions[index].name)
                        }
                    }
                    // displays it as a rotating selection
                    .pickerStyle(WheelPickerStyle())
                }
                
                
                Section(header: Text("Severity Rating")) {
                    // slider for severity of emotion
                    // store the value in the selected emotion's severity rating
                    // goes from 0 to 10, step size equals 1, where 0 is not severe
                    // and 10 is very severe
                    Slider(value: $emotions[selectedEmotionIndex].severity, in: 0.0...10.0, step: 1) {
                        Text("Severity")
                    } minimumValueLabel: {
                        Text("0 - Not Severe")
                    } maximumValueLabel: {
                        Text("10 - Very Severe")
                    }
                    .accentColor(.blue)
                }
                
                // reflection journal
                Section(header: Text("Written Reflection")) {
                    TextField(
                        "Why do you feel that way?",
                        text: $emotions[selectedEmotionIndex].reflection
                        // in the emotions array, access the emotion using its index, then set its reflection value
                    ).textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true).frame(height: 50).padding(.vertical, 10)
                    // expand length of review box
                }
                
                
                // also need to store the emotion object in core data here
                // once completed with emotion reflection, move to cooldown view
                NavigationLink(destination: CooldownView()) {
                    Text("Continue").onTapGesture {
                        // save the current emotion as the currently selected emotion object
                        let currentEmotion = emotions[selectedEmotionIndex]
                        // provide the currently selected emotion to the saveEmotion function in the view model, to save it to core data and view model's emotions array
                        viewmodelEmotions.saveEmotion(emotion: currentEmotion)
                    }
                }
            }
            
            }.navigationTitle("Emotions")
        }
    }

#Preview {
    EmotionScreener()
}
