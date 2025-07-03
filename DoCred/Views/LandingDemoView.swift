import SwiftUI

struct LandingDemoView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.accentColor)
                Text("Welcome to DoCred!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Gamified Chore & Proof Manager\nwith Social Features")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                Spacer()
                VStack(spacing: 16) {
                    Button(action: {
                        // Navigate to dashboard
                    }) {
                        Label("Go to Dashboard", systemImage: "list.bullet.rectangle")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.accentColor)
                            .cornerRadius(12)
                            .shadow(radius: 1)
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding()
        }
    }
}
