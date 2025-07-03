import SwiftUI

struct TaskCardView: View {
    let task: AppTask
    @State private var isPressed = false
    @State private var showCompletionAnimation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with title and XP
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text(task.details)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Completion checkmark animation
                if task.status == .approved {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                        .scaleEffect(showCompletionAnimation ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showCompletionAnimation)
                        .onAppear {
                            showCompletionAnimation = true
                        }
                }
                
                if let xp = task.score {
                    VStack(spacing: 2) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.yellow)
                            Text("+\(xp)")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.yellow)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.yellow.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
            }
            
            // Status and metadata
            HStack {
                // Status badge
                HStack(spacing: 6) {
                    Circle()
                        .fill(statusColor(for: task.status))
                        .frame(width: 8, height: 8)
                    Text(task.status.rawValue.capitalized)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(statusColor(for: task.status))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(statusColor(for: task.status).opacity(0.1))
                )
                
                Spacer()
                
                // Date
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Text(task.createdAt, style: .date)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                // Share button
                Button(action: {
                    shareTask()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(16)
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
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
    
    func statusColor(for status: TaskStatus) -> Color {
        switch status {
        case .approved:
            return Color.green
        case .pending:
            return Color.blue
        case .reviewed:
            return Color.orange
        }
    }
    
    func shareTask() {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
        }()
        let shareText = """
        Task: \(task.title)
        Description: \(task.details)
        Status: \(task.status.rawValue.capitalized)
        XP: \(task.score ?? 0)
        Created: \(dateFormatter.string(from: task.createdAt))
        
        Shared from DoCred App
        """
        
        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}