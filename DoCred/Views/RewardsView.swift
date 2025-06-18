import SwiftUI
import SwiftData

struct RewardsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var rewards: [Reward]
    @State private var showingAddReward = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(rewards) { reward in
                        RewardCard(reward: reward)
                    }
                }
                .padding()
            }
            .navigationTitle("Rewards")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddReward = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear {
            if rewards.isEmpty {
                createSampleRewards()
            }
        }
    }
    
    private func createSampleRewards() {
        let sampleRewards = [
            ("Pizza Night", "Order pizza for the whole house", 300, false),
            ("Movie Night", "Choose the movie for movie night", 150, false),
            ("Skip Dishes", "Skip your next dish duty", 100, false),
            ("Choose Music", "Control the house playlist for a week", 75, false),
            ("House Party", "Host a house party (with approval)", 500, true)
        ]
        
        for (name, rewardDescription, points, isGroup) in sampleRewards {
            let reward = Reward(
                id: UUID().uuidString,
                name: name,
                rewardDescription: rewardDescription,
                pointsCost: points,
                householdId: "demo-household",
                isGroupReward: isGroup
            )
            modelContext.insert(reward)
        }
    }
}

struct RewardCard: View {
    let reward: Reward
    @State private var showingRedeemAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(reward.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(reward.rewardDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(reward.pointsCost)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("points")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if reward.isGroupReward {
                HStack {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(.green)
                    Text("Group Reward")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Button("Redeem") {
                showingRedeemAlert = true
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .alert("Redeem Reward?", isPresented: $showingRedeemAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Redeem") {
                // Handle redemption
            }
        } message: {
            Text("This will cost \(reward.pointsCost) points. Are you sure?")
        }
    }
}

#Preview {
    RewardsView()
        .modelContainer(for: [Reward.self], inMemory: true)
} 