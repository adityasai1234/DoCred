import SwiftUI

struct TaskTimerView: View {
    @StateObject private var timer = TaskTimer()
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            if timer.isRunning {
                VStack(spacing: 8) {
                    Text("⏱️ \(timer.taskName)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(timer.formatTime(timer.elapsedTime))
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(themeManager.customAccentColor)
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            HapticManager.shared.mediumImpact()
                            timer.pauseTimer()
                        }) {
                            Label("Pause", systemImage: "pause.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.orange)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            HapticManager.shared.heavyImpact()
                            timer.stopTimer()
                        }) {
                            Label("Stop", systemImage: "stop.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            } else {
                VStack(spacing: 16) {
                    Text("⏱️ Task Timer")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
                    Text("Start timing your tasks to track productivity")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        HapticManager.shared.mediumImpact()
                        timer.startTimer(for: "Sample Task")
                    }) {
                        Label("Start Timer", systemImage: "play.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(themeManager.customAccentColor)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Task Timer")
        .navigationBarTitleDisplayMode(.inline)
    }
} 