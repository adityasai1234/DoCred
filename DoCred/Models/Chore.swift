import Foundation
import SwiftData

@Model
final class Chore {
    var id: String
    var name: String
    var choreDescription: String
    var points: Int
    var assignedUserId: String?
    var householdId: String
    var dueDate: Date
    var isCompleted: Bool
    var isRecurring: Bool
    var recurrencePattern: RecurrencePattern?
    var createdAt: Date
    var completedAt: Date?
    var proofSubmissions: [ProofSubmission]
    
    init(id: String, name: String, choreDescription: String, points: Int, householdId: String, dueDate: Date) {
        self.id = id
        self.name = name
        self.choreDescription = choreDescription
        self.points = points
        self.householdId = householdId
        self.dueDate = dueDate
        self.isCompleted = false
        self.isRecurring = false
        self.createdAt = Date()
        self.proofSubmissions = []
    }
}

enum RecurrencePattern: String, CaseIterable, Codable {
    case daily = "daily"
    case weekly = "weekly"
    case biweekly = "biweekly"
    case monthly = "monthly"
    
    var displayName: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .biweekly: return "Bi-weekly"
        case .monthly: return "Monthly"
        }
    }
} 