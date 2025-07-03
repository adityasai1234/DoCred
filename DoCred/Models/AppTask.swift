import Foundation
// import DoCred (not needed in Swift for models in same module)

// All enums and types should be accessible

enum RecurrenceRule: String, Codable, CaseIterable {
    case none, daily, weekly, monthly
}

struct AppTask: Identifiable, Codable {
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
    var recurrence: RecurrenceRule
    var recurrenceEndDate: Date?
}

enum TaskStatus: String, Codable {
    case pending, reviewed, approved
}

enum TaskCategory: String, CaseIterable {
    case personal = "Personal"
    case work = "Work"
    case health = "Health"
    case home = "Home"
    case learning = "Learning"
    
    var color: String {
        switch self {
        case .personal: return "blue"
        case .work: return "green"
        case .health: return "red"
        case .home: return "orange"
        case .learning: return "purple"
        }
    }
}
