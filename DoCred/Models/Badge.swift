import Foundation
import SwiftData

@Model
final class Badge {
    var id: String
    var name: String
    var badgeDescription: String
    var iconName: String
    var category: BadgeCategory
    var requirement: BadgeRequirement
    var isUnlocked: Bool
    var unlockedAt: Date?
    var userId: String
    
    init(id: String, name: String, badgeDescription: String, iconName: String, category: BadgeCategory, requirement: BadgeRequirement, userId: String) {
        self.id = id
        self.name = name
        self.badgeDescription = badgeDescription
        self.iconName = iconName
        self.category = category
        self.requirement = requirement
        self.isUnlocked = false
        self.userId = userId
    }
}

enum BadgeCategory: String, CaseIterable, Codable {
    case streak = "streak"
    case chores = "chores"
    case proof = "proof"
    case points = "points"
    case special = "special"
    
    var displayName: String {
        switch self {
        case .streak: return "Streaks"
        case .chores: return "Chores"
        case .proof: return "Proof"
        case .points: return "Points"
        case .special: return "Special"
        }
    }
}

struct BadgeRequirement: Codable {
    var type: RequirementType
    var value: Int
    
    enum RequirementType: String, Codable {
        case totalChores = "total_chores"
        case streakDays = "streak_days"
        case totalPoints = "total_points"
        case proofSubmissions = "proof_submissions"
        case specificChore = "specific_chore"
    }
} 