import Foundation
import SwiftData

@Model
final class Reward {
    var id: String
    var name: String
    var rewardDescription: String
    var pointsCost: Int
    var householdId: String
    var isGroupReward: Bool
    var isActive: Bool
    var createdAt: Date
    var redemptions: [RewardRedemption]
    
    init(id: String, name: String, rewardDescription: String, pointsCost: Int, householdId: String, isGroupReward: Bool = false) {
        self.id = id
        self.name = name
        self.rewardDescription = rewardDescription
        self.pointsCost = pointsCost
        self.householdId = householdId
        self.isGroupReward = isGroupReward
        self.isActive = true
        self.createdAt = Date()
        self.redemptions = []
    }
}

@Model
final class RewardRedemption {
    var id: String
    var rewardId: String
    var userId: String
    var redeemedAt: Date
    var pointsSpent: Int
    var isFulfilled: Bool
    
    init(id: String, rewardId: String, userId: String, pointsSpent: Int) {
        self.id = id
        self.rewardId = rewardId
        self.userId = userId
        self.pointsSpent = pointsSpent
        self.redeemedAt = Date()
        self.isFulfilled = false
    }
} 