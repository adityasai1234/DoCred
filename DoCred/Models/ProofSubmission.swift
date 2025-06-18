import Foundation
import SwiftData

@Model
final class ProofSubmission {
    var id: String
    var choreId: String
    var userId: String
    var imageURL: String?
    var videoURL: String?
    var comment: String?
    var submittedAt: Date
    var isVerified: Bool
    var verifiedBy: String?
    var verifiedAt: Date?
    var verificationStatus: VerificationStatus
    
    init(id: String, choreId: String, userId: String) {
        self.id = id
        self.choreId = choreId
        self.userId = userId
        self.submittedAt = Date()
        self.isVerified = false
        self.verificationStatus = .pending
    }
}

enum VerificationStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case approved = "approved"
    case rejected = "rejected"
    
    var displayName: String {
        switch self {
        case .pending: return "Pending"
        case .approved: return "Approved"
        case .rejected: return "Rejected"
        }
    }
    
    var color: String {
        switch self {
        case .pending: return "orange"
        case .approved: return "green"
        case .rejected: return "red"
        }
    }
} 