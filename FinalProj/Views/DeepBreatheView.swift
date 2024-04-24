//
//  DeepBreatheView.swift
//  FinalProj
//
//  Created by Colin  on 2024/4/22.
//

import SwiftUI

struct CooldownView: View {
    let totalTime = 60
    @State private var timeRemaining = 60
    @State private var progress: CGFloat = 1
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Time for a cool down...")
                Spacer()
                ZStack {
                    Circle()
                        .stroke(lineWidth: 5)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.blue, lineWidth: 5)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: progress)
                    
                    Text("Breathe")
                        .font(.largeTitle)
                }
                .frame(width: 200, height: 200)
                Spacer()
                Text("\(timeRemaining) seconds remaining...")
                Spacer()
            }
            .onAppear {
                self.startBreathingExercise()
            }
            .onReceive(timer) { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                    self.progress = CGFloat(self.timeRemaining) / CGFloat(self.totalTime)
                } else {
                    self.timer.upstream.connect().cancel()
                }
            }
        }
        
        // returns you to home view once time remaining is 0 aka you completed the deep breathing
        if timeRemaining == 0 {
            Text("Great work! You've successfully completed your exercise emotion reflection and deep breathing exercise.")
            
            NavigationLink(destination: Home()) {
                Text("Complete Reflection")
            }
        }
    }
    
    func startBreathingExercise() {
        // This function could be used to configure the exercise
        self.timeRemaining = totalTime
        self.progress = 1
    }
}

struct CooldownView_Previews: PreviewProvider {
    static var previews: some View {
        CooldownView()
    }
}
