import SwiftUI
import SwiftData

struct LeaderboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @State private var timeFilter: TimeFilter = .week
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Time filter
                Picker("Time Period", selection: $timeFilter) {
                    ForEach(TimeFilter.allCases, id: \.self) { filter in
                        Text(filter.displayName).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Leaderboard
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(rankedUsers.enumerated()), id: \.element.id) { index, user in
                            LeaderboardRow(
                                rank: index + 1,
                                user: user,
                                points: getPointsForUser(user)
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Leaderboard")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            if users.isEmpty {
                createSampleUsers()
            }
        }
    }
    
    private var rankedUsers: [User] {
        users.sorted { getPointsForUser($0) > getPointsForUser($1) }
    }
    
    private func getPointsForUser(_ user: User) -> Int {
        return user.totalPoints
    }
    
    private func createSampleUsers() {
        let sampleUsers = [
            ("Alex Johnson", 1850, 12, "alex@docred.com"),
            ("Sarah Chen", 1620, 8, "sarah@docred.com"),
            ("Mike Rodriguez", 1340, 5, "mike@docred.com"),
            ("Emma Wilson", 980, 3, "emma@docred.com"),
            ("David Kim", 720, 1, "david@docred.com")
        ]
        
        for (name, points, streak, email) in sampleUsers {
            let user = User(id: UUID().uuidString, email: email, name: name)
            user.totalPoints = points
            user.currentStreak = streak
            user.longestStreak = max(streak + 2, 14)
            modelContext.insert(user)
        }
    }
}

enum TimeFilter: CaseIterable {
    case week, month, allTime
    
    var displayName: String {
        switch self {
        case .week: return "Week"
        case .month: return "Month"
        case .allTime: return "All Time"
        }
    }
}

struct LeaderboardRow: View {
    let rank: Int
    let user: User
    let points: Int
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank badge
            ZStack {
                Circle()
                    .fill(rankColor)
                    .frame(width: 40, height: 40)
                
                Text("\(rank)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            // User avatar
            Circle()
                .fill(Color.blue.gradient)
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(user.name.prefix(1)))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            // User info
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "flame.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                    Text("\(user.currentStreak) day streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Points
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(points)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Text("points")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .brown
        default: return .blue
        }
    }
}

#Preview {
    LeaderboardView()
        .modelContainer(for: [User.self], inMemory: true)
} 