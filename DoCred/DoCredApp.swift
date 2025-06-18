//
//  DoCredApp.swift
//  DoCred
//
//  Created by Aditysai B on 18/06/25.
//

import SwiftUI
import SwiftData

@main
struct DoCredApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Household.self,
            Chore.self,
            ProofSubmission.self,
            Reward.self,
            RewardRedemption.self,
            Badge.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
