import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Dashboard")
                }
                .tag(0)
            
            ChoresView()
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Chores")
                }
                .tag(1)
            
            SubmitProofView()
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Submit Proof")
                }
                .tag(2)
            
            LeaderboardView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Leaderboard")
                }
                .tag(3)
            
            RewardsView()
                .tabItem {
                    Image(systemName: "gift.fill")
                    Text("Rewards")
                }
                .tag(4)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(5)
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [User.self, Household.self, Chore.self], inMemory: true)
} 