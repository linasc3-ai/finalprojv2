//
//  EmotionViewModel.swift
//  FinalProj
//
//  Created by Lina Chihoub on 4/24/24.
//


import Foundation
import SwiftUI
import CoreData

class EmotionViewModel: ObservableObject {
    
    // goal is to store the emotion data with core data
    
    // array to hold emotion data
    @Published var emotions: [Emotion] = []
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ModelEmotions")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // function to actually save the emotion
    func saveEmotion(emotion: Emotion) {
        // create new emotion object based on the data passed from the emotionScreener view
        // create a new emotion with the viewContext that contains emotion data from core data 
           let emotionEntry = EmotionObj(context: viewContext)
           emotionEntry.name = emotion.name
           emotionEntry.emoji = emotion.emoji
           emotionEntry.severity = emotion.severity
           emotionEntry.reflection = emotion.reflection

        // save the data to the core data store, as well as append to emotions array
           do {
               try viewContext.save()
               emotions.append(emotion)
           } catch let error as NSError {
               print("Could not save. \(error), \(error.userInfo)")
           }
       }
    
    // method to iterate through emojis in array and count the type of each one for future visualization
    
    var emotionsCount: [String: Int] { // will return counts dict
            var counts = [String: Int]() // counts dictionary to return amount by emoji
            for emotion in emotions { // iterate through each emotion
                counts[emotion.emoji, default: 0] += 1  // Counting occurrences of each emoji
            }
            return counts
        }
    
    // calculate average severity ratings for each emotions
    var averageSeverityByEmotion: [(name: String, averageSeverity: Double)] {
           let grouped = Dictionary(grouping: emotions) { $0.name } // group emotions by name
        
        // iterate through each emotion for each dict of emotion subtypes using map
           return grouped.map { group in
               let totalSeverity = group.value.reduce(0) { $0 + $1.severity } // sum severities for each object using reduce
               let averageSeverity = totalSeverity / Double(group.value.count) // calculate total severity by dividing
               return (name: group.key, averageSeverity: averageSeverity) // return the tuple containing name of emotion and its avg severity value 
           }
       }
}


