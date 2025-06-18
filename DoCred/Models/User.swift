import Foundation
import SwiftData

@Model
final class User {
    var id: String
    var email: String
    var name: String
    var avatarURL: String?
    var totalPoints: Int
    var currentStreak: Int
    var longestStreak: Int
    var householdId: String?
    var isAdmin: Bool
    var joinDate: Date
    var lastActivityDate: Date
    
    init(id: String, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
        self.totalPoints = 0
        self.currentStreak = 0
        self.longestStreak = 0
        self.isAdmin = false
        self.joinDate = Date()
        self.lastActivityDate = Date()
    }
} 