import SwiftUI

struct MiniGameSelectionView: View {
    var onSelect: (MiniGameType) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Text("Choose a Mini-Game")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 32)
                
                ForEach(MiniGameType.allCases, id: \.self) { game in
                    Button(action: {
                        onSelect(game)
                        dismiss()
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: game.icon)
                                .font(.system(size: 32))
                            Text(game.title)
                                .font(.system(size: 20, weight: .semibold))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Mini-Games")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

enum MiniGameType: CaseIterable, Identifiable {
    case memoryMatch, quickMath, wordScramble

    var id: Self { self }
    
    var title: String {
        switch self {
        case .memoryMatch: return "Memory Match"
        case .quickMath: return "Quick Math"
        case .wordScramble: return "Word Scramble"
        }
    }
    var icon: String {
        switch self {
        case .memoryMatch: return "brain.head.profile"
        case .quickMath: return "plus.slash.minus"
        case .wordScramble: return "textformat.abc"
        }
    }
} 