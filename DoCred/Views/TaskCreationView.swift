import SwiftUI

private let mockUsers = ["demoUser1", "demoUser2", "demoUser3"]
private let mockTeams = ["team1", "team2"]

struct TaskCreationView: View {
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var assignedTo: String = ""
    @State private var teamId: String = ""
    @State private var recurrence: RecurrenceRule = .none
    @State private var recurrenceEndDate: Date = Date()
    @State private var score: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Task Details")) {
                TextField("Title", text: $title)
                    .autocapitalization(.sentences)
                    .disableAutocorrection(true)
                TextEditor(text: $details)
                    .frame(minHeight: 80)
                    .autocapitalization(.sentences)
                    .disableAutocorrection(true)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2))
                    )
                TextField("Score", text: $score)
                    .keyboardType(.numberPad)
            }
            Section(header: Text("Assign To")) {
                Picker("User", selection: $assignedTo) {
                    Text("None").tag("")
                    ForEach(mockUsers, id: \.self) { user in
                        Text(user).tag(user)
                    }
                }
                Picker("Team", selection: $teamId) {
                    Text("None").tag("")
                    ForEach(mockTeams, id: \.self) { team in
                        Text(team).tag(team)
                    }
                }
            }
            Section(header: Text("Recurrence")) {
                Picker("Recurrence", selection: $recurrence) {
                    ForEach(RecurrenceRule.allCases, id: \.self) { rule in
                        Text(rule.rawValue.capitalized).tag(rule)
                    }
                }
                if recurrence != .none {
                    DatePicker("End Date", selection: $recurrenceEndDate, displayedComponents: .date)
                }
            }
            Button("Create Task") {
                createTask()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Task Creation")
    }
    
    private func createTask() {
        // Validate title is non-empty
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Title is required.")
            return
        }
        // Validate score is numeric
        guard let scoreInt = Int(score) else {
            print("Score must be a number.")
            return
        }
        let newTask = AppTask(
            id: UUID().uuidString,
            title: title,
            details: details,
            status: TaskStatus.pending,
            createdAt: Date(),
            updatedAt: nil,
            assignedTo: assignedTo,
            reviewedBy: nil,
            score: scoreInt,
            teamId: teamId.isEmpty ? nil : teamId,
            recurrence: recurrence,
            recurrenceEndDate: recurrence == .none ? nil : recurrenceEndDate
        )
        print("Created Task: \(newTask)")
    }
}
