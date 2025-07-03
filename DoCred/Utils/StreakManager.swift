import Foundation

class StreakManager: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    
    static let shared = StreakManager()
    private init() {
        loadStreakData()
    }
    
    func updateStreak(completedToday: Bool) {
        if completedToday {
            currentStreak += 1
            if currentStreak > longestStreak {
                longestStreak = currentStreak
            }
        } else {
            currentStreak = 0
        }
        saveStreakData()
    }
    
    func getStreakEmoji() -> String {
        if currentStreak >= 7 {
            return "🔥🔥🔥"
        } else if currentStreak >= 5 {
            return "🔥🔥"
        } else if currentStreak >= 3 {
            return "🔥"
        } else {
            return "💪"
        }
    }
    
    private func loadStreakData() {
        currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        longestStreak = UserDefaults.standard.integer(forKey: "longestStreak")
    }
    
    private func saveStreakData() {
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        UserDefaults.standard.set(longestStreak, forKey: "longestStreak")
    }
} 