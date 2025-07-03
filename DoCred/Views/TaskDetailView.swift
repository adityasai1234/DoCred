import SwiftUI

struct TaskDetailView: View {
    let task: Task
    @State private var showFairnessVoting = false
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(task.title)
                .font(.largeTitle)
                .bold()
            Text(task.details)
                .font(.body)
            Text("Status: \(task.status.rawValue.capitalized)")
                .font(.headline)
            Button("Appeal Assignment") {
                showFairnessVoting = true
            }
            .buttonStyle(.borderedProminent)
            Spacer()
            NavigationLink(destination: SubmitProofView(task: task)) {
                Text("Submit Proof")
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .navigationTitle("Task Detail")
        .sheet(isPresented: $showFairnessVoting) {
            // Replace with your actual user list if available
            FairnessVotingView(viewModel: FairnessVotingViewModel(choreId: task.id, userIds: ["Alice", "Bob", "Charlie", "Dana"]))
        }
    }
}
