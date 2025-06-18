import SwiftUI
import SwiftData

struct ChoresView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var chores: [Chore]
    @State private var filterOption: ChoreFilter = .all
    
    var body: some View {
        NavigationView {
            VStack {
                // Filter buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(ChoreFilter.allCases, id: \.self) { filter in
                            FilterButton(
                                title: filter.displayName,
                                isSelected: filterOption == filter,
                                action: { filterOption = filter }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Chores list
                List {
                    ForEach(filteredChores) { chore in
                        ChoreRowView(chore: chore)
                    }
                    .onDelete(perform: deleteChores)
                }
            }
            .navigationTitle("Chores")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { 
                        // Add chore functionality - placeholder
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear {
            if chores.isEmpty {
                createSampleChores()
            }
        }
    }
    
    private var filteredChores: [Chore] {
        switch filterOption {
        case .all:
            return chores.sorted { $0.dueDate < $1.dueDate }
        case .today:
            let today = Calendar.current.startOfDay(for: Date())
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            return chores.filter { chore in
                chore.dueDate >= today && chore.dueDate < tomorrow
            }.sorted { $0.dueDate < $1.dueDate }
        case .upcoming:
            let today = Calendar.current.startOfDay(for: Date())
            return chores.filter { chore in
                chore.dueDate > today
            }.sorted { $0.dueDate < $1.dueDate }
        case .completed:
            return chores.filter { $0.isCompleted }.sorted { $0.completedAt ?? Date() > $1.completedAt ?? Date() }
        case .overdue:
            let now = Date()
            return chores.filter { chore in
                !chore.isCompleted && chore.dueDate < now
            }.sorted { $0.dueDate < $1.dueDate }
        }
    }
    
    private func deleteChores(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredChores[index])
            }
        }
    }
    
    private func createSampleChores() {
        let sampleChores = [
            ("Dishes", "Wash all dishes and put them away", 15, Date()),
            ("Vacuum Living Room", "Vacuum the entire living room area", 20, Calendar.current.date(byAdding: .hour, value: 2, to: Date())!),
            ("Take Out Trash", "Empty all trash bins and take to dumpster", 10, Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
            ("Clean Bathroom", "Clean toilet, sink, and shower", 25, Calendar.current.date(byAdding: .day, value: 2, to: Date())!),
            ("Laundry", "Wash, dry, and fold laundry", 30, Calendar.current.date(byAdding: .day, value: 3, to: Date())!)
        ]
        
        for (name, choreDescription, points, dueDate) in sampleChores {
            let chore = Chore(
                id: UUID().uuidString,
                name: name,
                choreDescription: choreDescription,
                points: points,
                householdId: "demo-household",
                dueDate: dueDate
            )
            modelContext.insert(chore)
        }
    }
}

enum ChoreFilter: CaseIterable {
    case all, today, upcoming, completed, overdue
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .today: return "Today"
        case .upcoming: return "Upcoming"
        case .completed: return "Completed"
        case .overdue: return "Overdue"
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct ChoreRowView: View {
    let chore: Chore
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: { showingDetail = true }) {
            HStack(spacing: 12) {
                // Status indicator
                Circle()
                    .fill(statusColor)
                    .frame(width: 12, height: 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(chore.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(chore.points) pts")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    
                    Text(chore.choreDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(chore.dueDate, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if chore.isCompleted {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            ChoreDetailView(chore: chore)
        }
    }
    
    private var statusColor: Color {
        if chore.isCompleted {
            return .green
        } else if chore.dueDate < Date() {
            return .red
        } else {
            return .orange
        }
    }
}

struct ChoreDetailView: View {
    let chore: Chore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        Text(chore.choreDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Points")
                            .font(.headline)
                        Text("\(chore.points) points")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Due Date")
                            .font(.headline)
                        Text(chore.dueDate, style: .date)
                            .font(.body)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Status")
                            .font(.headline)
                        HStack {
                            Circle()
                                .fill(statusColor)
                                .frame(width: 12, height: 12)
                            Text(statusText)
                                .font(.body)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(chore.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var statusColor: Color {
        if chore.isCompleted {
            return .green
        } else if chore.dueDate < Date() {
            return .red
        } else {
            return .orange
        }
    }
    
    private var statusText: String {
        if chore.isCompleted {
            return "Completed"
        } else if chore.dueDate < Date() {
            return "Overdue"
        } else {
            return "Pending"
        }
    }
}

#Preview {
    ChoresView()
        .modelContainer(for: [Chore.self], inMemory: true)
} 