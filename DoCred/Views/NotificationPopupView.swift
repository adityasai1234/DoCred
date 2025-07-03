import SwiftUI

struct NotificationPopupView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("🔔 Notification")
                .font(.title2)
            Text("You have a new task assigned!")
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
        .shadow(radius: 4)
        .padding()
    }
}
