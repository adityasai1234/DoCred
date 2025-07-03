import Foundation
// import DoCred (not needed in Swift for models in same module)

enum RecurrenceRule: String, Codable, CaseIterable {
    case none, daily, weekly, monthly
}

struct Task: Identifiable, Codable {
    var id: String
    var title: String
    var details: String
    var status: TaskStatus
    var createdAt: Date
    var updatedAt: Date?
    var assignedTo: String 
    var reviewedBy: String? 
    var score: Int?
    var teamId: String?
    var priority: TaskPriority
    var recurrence: RecurrenceRule
    var recurrenceEndDate: Date?
}

enum TaskStatus: String, Codable {
    case pending, reviewed, approved
}

enum TaskPriority: String, Codable, CaseIterable {
    case low, medium, high
    
    var emoji: String {
        switch self {
        case .low: return "🟢"
        case .medium: return "🟡"
        case .high: return "🔴"
        }
    }
    
    var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "orange"
        case .high: return "red"
        }
    }
}
