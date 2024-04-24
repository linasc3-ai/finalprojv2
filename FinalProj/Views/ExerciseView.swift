//
//  ExerciseView.swift
//  FinalProj
//
//  Created by Colin  on 2024/4/22.
//

import SwiftUI
import CoreMotion

struct ExerciseView: View {
    @StateObject private var viewModel = ExerciseViewModel()
    @State private var showCountdownView = false
    @State private var showPermissionDeniedAlert = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Let's Get Started!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                TextField("Enter exercising duration (minutes)", text: $viewModel.duration)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Start") {
                    // Check if step counting is available before starting
                    if CMPedometer.isStepCountingAvailable() {
                        viewModel.startExercise()
                        withAnimation {
                            showCountdownView = true
                        }
                    } else {
                        showPermissionDeniedAlert = true
                    }
                }
                .disabled(viewModel.isCollectingData || viewModel.duration.isEmpty)
                .buttonStyle(StartButtonStyle())
                .padding()
                .alert(isPresented: $showPermissionDeniedAlert) {
                    Alert(
                        title: Text("Permission Denied"),
                        message: Text("Please enable motion & fitness tracking in settings."),
                        dismissButton: .default(Text("OK"))
                    )
                }

                NavigationLink(destination: CountdownView(viewModel: viewModel), isActive: $showCountdownView) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.requestPedometerAuthorization() // Correct function name
        }
    }
}

struct StartButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView()
    }
}
