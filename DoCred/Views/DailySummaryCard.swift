import SwiftUI

struct DailySummaryCard: View {
    let completedTasks: Int
    let totalTasks: Int
    let streakDays: Int
    let totalXP: Int
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                
                Text("Today's Summary")
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                Text(Date(), style: .date)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            // Stats grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatItem(
                    title: "Completed",
                    value: "\(completedTasks)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                StatItem(
                    title: "Total Tasks",
                    value: "\(totalTasks)",
                    icon: "list.bullet",
                    color: .blue
                )
                
                StatItem(
                    title: "Streak",
                    value: "\(streakDays) days",
                    icon: "flame.fill",
                    color: .orange
                )
                
                StatItem(
                    title: "XP Earned",
                    value: "+\(totalXP)",
                    icon: "star.fill",
                    color: .yellow
                )
            }
            
            // Progress bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Completion Rate")
                        .font(.system(size: 14, weight: .medium))
                    Spacer()
                    Text("\(Int((Double(completedTasks) / Double(max(totalTasks, 1))) * 100))%")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.blue)
                }
                
                ProgressView(value: Double(completedTasks), total: Double(max(totalTasks, 1)))
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.black.opacity(0.08),
                    radius: 8,
                    x: 0,
                    y: 4
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.systemGray5), lineWidth: 0.5)
                )
        )
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
} 