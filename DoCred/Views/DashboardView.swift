import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @Query private var chores: [Chore]
    @State private var currentUser: User?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with user info and points
                    UserStatsCard(user: currentUser)
                    
                    // Streak card
                    StreakCard(user: currentUser)
                    
                    // Today's chores
                    TodaysChoresCard(chores: todaysChores)
                    
                    // Quick actions
                    QuickActionsCard()
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            setupCurrentUser()
        }
    }
    
    private var todaysChores: [Chore] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        return chores.filter { chore in
            chore.dueDate >= today && chore.dueDate < tomorrow
        }
    }
    
    private func setupCurrentUser() {
        // For demo purposes, create a user if none exists
        if users.isEmpty {
            let newUser = User(id: UUID().uuidString, email: "demo@docred.com", name: "Demo User")
            newUser.totalPoints = 1250
            newUser.currentStreak = 7
            newUser.longestStreak = 14
            modelContext.insert(newUser)
            currentUser = newUser
        } else {
            currentUser = users.first
        }
    }
}

struct UserStatsCard: View {
    let user: User?
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Welcome back!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(user?.name ?? "User")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                
                Circle()
                    .fill(Color.blue.gradient)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(user?.name.prefix(1) ?? "U"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
            }
            
            HStack(spacing: 20) {
                VStack {
                    Text("\(user?.totalPoints ?? 0)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("Total Points")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                VStack {
                    Text("\(user?.currentStreak ?? 0)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text("Day Streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct StreakCard: View {
    let user: User?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                Text("Current Streak")
                    .font(.headline)
                Spacer()
                Text("🔥 \(user?.currentStreak ?? 0) days")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
            
            if let streak = user?.currentStreak, streak > 0 {
                ProgressView(value: Double(streak), total: 14.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                
                Text("Keep it up! \(14 - streak) more days for the 2x multiplier!")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("Start your streak by completing a chore today!")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct TodaysChoresCard: View {
    let chores: [Chore]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checklist")
                    .foregroundColor(.blue)
                Text("Today's Chores")
                    .font(.headline)
                Spacer()
                Text("\(chores.count)")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
            
            if chores.isEmpty {
                Text("No chores due today! 🎉")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical)
            } else {
                ForEach(chores.prefix(3)) { chore in
                    HStack {
                        Circle()
                            .fill(chore.isCompleted ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                        Text(chore.name)
                            .font(.subheadline)
                        Spacer()
                        Text("\(chore.points) pts")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                if chores.count > 3 {
                    Text("+ \(chores.count - 3) more...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct QuickActionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
            
            HStack(spacing: 16) {
                NavigationLink(destination: SubmitProofView()) {
                    VStack {
                        Image(systemName: "camera.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("Submit Proof")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue.gradient)
                    .cornerRadius(8)
                }
                
                NavigationLink(destination: ChoresView()) {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("Add Chore")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.green.gradient)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [User.self, Chore.self], inMemory: true)
} 