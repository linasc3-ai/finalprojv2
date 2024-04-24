//
//  Home.swift
//  FinalProj
//
//  Created by Lina Chihoub on 4/24/24.
//

import SwiftUI
import Charts // to use for displaying data

struct Home: View {
    // view model containing the emotion data
    @StateObject var viewmodelEmotions = EmotionViewModel()
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack {
                Text("My Exercise Summary").font(.largeTitle).fontWeight(.bold).padding().foregroundStyle(.white)
                
                // display statistics about the exercise
                // number of steps
                
                Text("My Mental Health Summary").font(.largeTitle).fontWeight(.bold).padding().foregroundStyle(.white)
                // display statistics about the mental health journey
                
                // chart for types of emotions
                // ge the counts of each emoji
                let counts = viewmodelEmotions.emotionsCount
                
                
                HStack  {
                    
                    // iterate through each key aka emoji in counts
                    // pull out count for the emoji
                    // display the emoji as key, count as y axis (histogram)
                    Text("Emotion Frequency").padding().foregroundStyle(.white)
                    Chart {
                        ForEach(Array(counts.keys), id: \.self) { key in
                            if let count = counts[key] {
                                BarMark(
                                    x: .value("Emoji", key),
                                    y: .value("Count", count)
                                )
                                .foregroundStyle(by: .value("Emoji", key))
                            }
                        }
                    }
                    .frame(height: 300)
                    .padding()
                    
                    // display severity ratings
                    Text("Severity ").padding().foregroundStyle(.white)
                    
                    // for each tuple containing emotion and average severity, display on bar chart
                    Chart {
                                ForEach(viewmodelEmotions.averageSeverityByEmotion, id: \.name) { emotion in
                                    BarMark(
                                        x: .value("Emotion", emotion.name),
                                        y: .value("Severity", emotion.averageSeverity)
                                    )
                                }
                            }
                            .chartXAxis {
                                AxisMarks(values: .automatic) { value in
                                    AxisValueLabel(value.as(String.self) ?? "", centered: true)
                                }
                            }
                            .frame(height: 300)
                            .padding()
                            .navigationTitle("Average Emotion Severity Overview")
                }
                
                
                    // display past reflections
                List {
                    Section(header: Text("Past Reflections")) {
                        if viewmodelEmotions.emotions.isEmpty {
                            Text("No reflections yet")
                        } else {
                            ForEach(viewmodelEmotions.emotions, id: \.id) { emotion in
                                Text(emotion.reflection)
                            }
                        }
                    }
                }
                    
                
                
                // start new workout button
                HStack {
                    Text("Ready to workout?").font(.largeTitle).fontWeight(.bold).padding().foregroundStyle(.white)
                    
                    NavigationLink(destination: ExerciseView()) {
                        Text("Start Workout").foregroundStyle(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    Home()
}
