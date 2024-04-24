//
//  CountdownView.swift
//  FinalProj
//
//  Created by Colin  on 2024/4/22.
//

import SwiftUI

struct CountdownView: View {
    @ObservedObject var viewModel: ExerciseViewModel
    @State private var progress: CGFloat = 1.0

    var body: some View {
        VStack {
            Text("Keep moving and watch your progress!")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()

            ZStack {
                ProgressCircleView(progress: $progress)
                
                VStack {
                    Text("\(viewModel.timeRemaining) seconds")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("Steps: \(viewModel.steps)")
                        .font(.headline)
                        .padding(.top, 20)
                }
            }
            .frame(width: 250, height: 250)

            // Additional UI or functionality can be added here
        }
        .onReceive(viewModel.timerPublisher) { _ in
            let totalDuration = Double(viewModel.duration) ?? 0
            progress = CGFloat(viewModel.timeRemaining) / (totalDuration * 60.0)
        }
        .onAppear {
            let totalDuration = Double(viewModel.duration) ?? 0
            viewModel.timeRemaining = Int(totalDuration * 60.0)
            progress = 1.0
        }
    }
}

// Helper view to draw the progress circle
struct ProgressCircleView: View {
    @Binding var progress: CGFloat
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 20)
            .opacity(0.3)
            .foregroundColor(Color.gray)
        
        Circle()
            .trim(from: 0, to: progress)
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
            .rotationEffect(.degrees(-90))
            .animation(.linear, value: progress)
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(viewModel: ExerciseViewModel())
    }
}
