import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel = DashboardViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showMiniGame = false
    @State private var selectedMiniGame: MiniGameType? = nil
    @State private var searchText = ""
    @State private var sortOption: SortOption = .date
    
    enum SortOption: String, CaseIterable {
        case date = "Date"
        case status = "Status"
        case title = "Title"
        case priority = "Priority"
    }
    
    var filteredTasks: [AppTask] {
        if searchText.isEmpty {
            return viewModel.tasks
        } else {
            return viewModel.tasks.filter { task in
                task.title.localizedCaseInsensitiveContains(searchText) ||
                task.details.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var sortedTasks: [AppTask] {
        switch sortOption {
        case .date:
            return filteredTasks.sorted { $0.createdAt > $1.createdAt }
        case .status:
            return filteredTasks.sorted { $0.status.rawValue < $1.status.rawValue }
        case .title:
            return filteredTasks.sorted { $0.title < $1.title }
        case .priority:
            return filteredTasks.sorted { ($0.score ?? 0) > ($1.score ?? 0) }
        }
    }
    
    var body: some View {
        ScrollView {
            mainContent
        }
        .refreshable {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            viewModel.loadDashboard(userId: "demoUserId")
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    Color(.systemGray6).opacity(0.3)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation(.spring()) {
                        themeManager.toggleDarkMode()
                        HapticManager.shared.mediumImpact()
                    }
                }) {
                    Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                        .font(.system(size: 22))
                        .foregroundColor(themeManager.isDarkMode ? .yellow : .orange)
                        .rotationEffect(.degrees(themeManager.isDarkMode ? 20 : 0))
                        .scaleEffect(themeManager.isDarkMode ? 1.1 : 1.0)
                        .shadow(radius: 2)
                }
                .accessibilityLabel(themeManager.isDarkMode ? "Switch to Day Mode" : "Switch to Night Mode")
            }
        }
        .onAppear {
            viewModel.loadDashboard(userId: "demoUserId")
        }
        .sheet(isPresented: $showMiniGame) {
            MiniGameSelectionView { game in
                selectedMiniGame = game
            }
        }
        .sheet(item: $selectedMiniGame) { game in
            switch game {
            case .memoryMatch:
                MiniGameView(users: ["Alice", "Bob", "Charlie", "Dana"])
            case .quickMath:
                Text("Quick Math Game Coming Soon!")
                    .font(.largeTitle)
                    .padding()
            case .wordScramble:
                Text("Word Scramble Game Coming Soon!")
                    .font(.largeTitle)
                    .padding()
            }
        }
    }

    private var mainContent: some View {
        VStack(spacing: 24) {
            searchBar
            headerSection
            dailySummary
            tasksSection
            miniGameSection
        }
        .padding(.bottom, 100)
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search tasks...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let user = viewModel.user {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello, \(user.name)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text("Ready to tackle today's tasks?")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Today's Progress")
                        .font(.system(size: 18, weight: .semibold))
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                        Text("\(viewModel.tasks.filter { $0.status == .approved }.count)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                    Text("\(viewModel.tasks.filter { $0.status == .approved }.count)/\(viewModel.tasks.count)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                ProgressView(value: Double(viewModel.tasks.filter { $0.status == .approved }.count), total: Double(max(viewModel.tasks.count, 1)))
                    .progressViewStyle(LinearProgressViewStyle(tint: themeManager.customAccentColor))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    private var dailySummary: some View {
        DailySummaryCard(
            completedTasks: viewModel.tasks.filter { $0.status == .approved }.count,
            totalTasks: viewModel.tasks.count,
            streakDays: 7, // Mock data
            totalXP: viewModel.tasks.filter { $0.status == .approved }.reduce(0) { $0 + ($1.score ?? 0) }
        )
        .padding(.horizontal, 20)
    }

    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your Tasks")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                Spacer()
                Menu {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Button(action: {
                            sortOption = option
                            HapticManager.shared.lightImpact()
                        }) {
                            HStack {
                                Text(option.rawValue)
                                if sortOption == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 12))
                        Text("Sort")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(themeManager.customAccentColor)
                }
            }
            .padding(.horizontal, 20)
            LazyVStack(spacing: 12) {
                ForEach(sortedTasks) { task in
                    NavigationLink(destination: TaskDetailView(task: task)) {
                        TaskCardView(task: task)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var miniGameSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                QuickActionButton(
                    title: "Mini-Game",
                    icon: "gamecontroller.fill",
                    color: .purple
                ) {
                    showMiniGame = true
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.mediumImpact()
            action()
        }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: Color.black.opacity(0.05),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray5), lineWidth: 0.5)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
