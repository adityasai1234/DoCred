import Foundation
import Combine

class TaskTimer: ObservableObject {
    @Published var isRunning = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var taskName: String = ""
    
    private var timer: Timer?
    private var startTime: Date?
    
    func startTimer(for taskName: String) {
        self.taskName = taskName
        self.startTime = Date()
        self.isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let startTime = self.startTime {
                self.elapsedTime = Date().timeIntervalSince(startTime)
            }
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        elapsedTime = 0
        taskName = ""
        startTime = nil
    }
    
    func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
} 