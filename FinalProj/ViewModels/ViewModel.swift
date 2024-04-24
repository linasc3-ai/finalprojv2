//
//  ViewModel.swift
//  FinalProj
//
//  Created by Colin  on 2024/4/22.
//

import Foundation
import CoreMotion
import Combine

class ExerciseViewModel: ObservableObject {
    @Published var duration = ""
    @Published var timeRemaining: Int = 0
    @Published var steps: Int = 0
    @Published var isCollectingData: Bool = false
    private var timer: Timer?
    let timerPublisher = PassthroughSubject<Void, Never>() // Publisher for timer ticks
    private let pedometer = CMPedometer()
    private let defaults = UserDefaults.standard
    
    init() {
        requestPedometerAuthorization() // Request authorization upon initialization
    }
    
    func requestPedometerAuthorization() {
        // Checking if step counting is available
        guard CMPedometer.isStepCountingAvailable() else {
            // If not available, you might want to inform the user
            return
        }
        
        // Requesting authorization - this will prompt the user
        pedometer.queryPedometerData(from: Date(), to: Date()) { _, _ in
            // The completion handler is required but we don't need to do anything here for now.
        }
    }
    
    func saveExerciseData(emotion: Emotion) {
        let exerciseData = ExerciseData(date: Date(), steps: steps, duration: Int(duration) ?? 0, emotion: emotion)
        do {
            let encodedData = try JSONEncoder().encode(exerciseData)
            defaults.set(encodedData, forKey: "ExerciseData")
        } catch {
            print("Unable to Save Exercise Data: \(error)")
        }
    }
    
    func loadExerciseData() -> ExerciseData? {
        guard let savedData = defaults.data(forKey: "ExerciseData") else { return nil }
        do {
            let decodedData = try JSONDecoder().decode(ExerciseData.self, from: savedData)
            return decodedData
        } catch {
            print("Unable to Load Exercise Data: \(error)")
            return nil
        }
    }
    
    func startExercise() {
        guard let enteredDuration = Int(duration), enteredDuration > 0 else {
            return
        }
        
        self.timeRemaining = enteredDuration * 60 // Convert minutes to seconds
        self.isCollectingData = true
        startPedometer()
        startTimer()
    }
    
    func stopExercise() {
        self.timer?.invalidate()
        self.timer = nil
        self.isCollectingData = false
        self.pedometer.stopUpdates()
    }
    
    private func startPedometer() {
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Date()) { [weak self] (data, error) in
                guard let self = self, error == nil, let data = data else { return }
                DispatchQueue.main.async {
                    self.steps = data.numberOfSteps.intValue
                }
            }
        }
    }
    
    private func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.timerPublisher.send() // Publish timer tick
            } else {
                self.stopExercise()
            }
        }
    }
}
