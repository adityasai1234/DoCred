import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @State private var currentUser: User?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Circle()
                            .fill(Color.blue.gradient)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text(String(currentUser?.name.prefix(1) ?? "U"))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentUser?.name ?? "User")
                                .font(.headline)
                            Text(currentUser?.email ?? "user@example.com")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Stats") {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.blue)
                        Text("Total Points")
                        Spacer()
                        Text("\(currentUser?.totalPoints ?? 0)")
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("Current Streak")
                        Spacer()
                        Text("\(currentUser?.currentStreak ?? 0) days")
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.yellow)
                        Text("Longest Streak")
                        Spacer()
                        Text("\(currentUser?.longestStreak ?? 0) days")
                            .fontWeight(.semibold)
                    }
                }
                
                Section("Settings") {
                    NavigationLink(destination: Text("Household Settings")) {
                        Label("Household", systemImage: "house.fill")
                    }
                    
                    NavigationLink(destination: Text("Notifications")) {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                    
                    NavigationLink(destination: Text("Privacy")) {
                        Label("Privacy", systemImage: "lock.fill")
                    }
                }
                
                Section("Support") {
                    NavigationLink(destination: Text("Help Center")) {
                        Label("Help Center", systemImage: "questionmark.circle.fill")
                    }
                    
                    NavigationLink(destination: Text("About")) {
                        Label("About DoCred", systemImage: "info.circle.fill")
                    }
                }
                
                Section {
                    Button("Sign Out") {
                        // Handle sign out
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            if users.isEmpty {
                let user = User(id: UUID().uuidString, email: "demo@docred.com", name: "Demo User")
                user.totalPoints = 1250
                user.currentStreak = 7
                user.longestStreak = 14
                modelContext.insert(user)
                currentUser = user
            } else {
                currentUser = users.first
            }
        }
    }
}

#Preview {
    ProfileView()
        .modelContainer(for: [User.self], inMemory: true)
} 