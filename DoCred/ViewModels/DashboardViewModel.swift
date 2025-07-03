import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    @Published var tasks: [AppTask] = []
    @Published var user: User?
    
    func loadDashboard(userId: String) {
        // Mock user
        self.user = User(id: userId, name: "Demo User", email: "demo@example.com", credibilityScore: 100, teamId: nil, badges: ["Starter"], role: .member)
        // Mock tasks with XP
        self.tasks = [
            AppTask(id: "task1", title: "Take out trash", details: "Take out the trash before 8pm", status: TaskStatus.approved, createdAt: Date(), updatedAt: nil, assignedTo: userId, reviewedBy: nil, score: 10, teamId: nil, recurrence: RecurrenceRule.none, recurrenceEndDate: nil),
            AppTask(id: "task2", title: "Wash dishes", details: "Wash all dishes after dinner", status: TaskStatus.pending, createdAt: Date(), updatedAt: nil, assignedTo: userId, reviewedBy: nil, score: 7, teamId: nil, recurrence: RecurrenceRule.none, recurrenceEndDate: nil)
        ]
    }
}
