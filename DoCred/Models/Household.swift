import Foundation
import SwiftData

@Model
final class Household {
    var id: String
    var name: String
    var inviteCode: String
    var adminUserId: String
    var createdAt: Date
    var settings: HouseholdSettings
    
    init(id: String, name: String, adminUserId: String) {
        self.id = id
        self.name = name
        self.adminUserId = adminUserId
        self.inviteCode = String(format: "%06d", Int.random(in: 100000...999999))
        self.createdAt = Date()
        self.settings = HouseholdSettings()
    }
}

struct HouseholdSettings: Codable {
    var defaultChorePoints: Int = 10
    var streakMultipliers: [Int: Double] = [3: 1.25, 7: 1.75, 14: 2.5]
    var penaltyPoints: Int = -15
    var autoRotateChores: Bool = true
    var requireProofVerification: Bool = true
} 