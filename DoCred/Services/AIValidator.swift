import Foundation

class AIValidator {
    static let shared = AIValidator()
    private init() {}
    
    func validateProof(proof: Proof, completion: @escaping (Result<Int, Error>) -> Void) {
    }
    
    func generateResume(for user: User, completion: @escaping (Result<String, Error>) -> Void) {
    }
} 
