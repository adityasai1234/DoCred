import SwiftUI

struct QuickTaskTemplatesView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    
    let templates = [
        AppTaskTemplate(title: "Clean Room", description: "Tidy up and organize your space", icon: "house.fill", color: .blue),
        AppTaskTemplate(title: "Exercise", description: "30 minutes of physical activity", icon: "figure.run", color: .green),
        AppTaskTemplate(title: "Study", description: "Focus on learning for 1 hour", icon: "book.fill", color: .purple),
        AppTaskTemplate(title: "Cook Meal", description: "Prepare a healthy meal", icon: "fork.knife", color: .orange),
        AppTaskTemplate(title: "Read", description: "Read for 20 minutes", icon: "book.closed.fill", color: .indigo),
        AppTaskTemplate(title: "Meditate", description: "10 minutes of mindfulness", icon: "brain.head.profile", color: .pink)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(templates) { template in
                        TaskTemplateCard(template: template) {
                            // Handle template selection
                            HapticManager.shared.mediumImpact()
                            dismiss()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Quick Templates")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AppTaskTemplate: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct TaskTemplateCard: View {
    let template: AppTaskTemplate
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: template.icon)
                    .font(.system(size: 32))
                    .foregroundColor(template.color)
                
                VStack(spacing: 4) {
                    Text(template.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(template.description)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
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
                            .stroke(template.color.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
} 
