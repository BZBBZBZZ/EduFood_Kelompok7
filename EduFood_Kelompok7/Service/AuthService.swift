//  Created by Obie Zuriel on 12/05/26.

import Foundation
import Supabase

protocol AuthServiceProtocol {
    func signUp(email: String, password: String, nama: String) async throws
    func signIn(email: String, password: String) async throws -> UserModel
    func signOut() async throws
    func updateProfile(newName: String, oldPassword: String?, newPassword: String?) async throws -> String
    func fetchUserScoreAndRank() async throws -> (Int, Int?)
}

class AuthService: AuthServiceProtocol {
    let client = SupabaseService.shared.client
    
    func signUp(email: String, password: String, nama: String) async throws {
        let response = try await client.auth.signUp(email: email, password: password)
        let newUser = UserModel(
            id: response.user.id,
            nama: nama,
            email: email,
            score: 0,
            role: "user"
        )
        
        try await client.database
            .from("users")
            .insert(newUser)
            .execute()
    }
    
    func signIn(email: String, password: String) async throws -> UserModel {
        try await client.auth.signIn(email: email, password: password)
        let user: UserModel = try await client.database
            .from("users")
            .select()
            .eq("email", value: email)
            .single()
            .execute()
            .value
        return user
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    func updateProfile(newName: String, oldPassword: String?, newPassword: String?) async throws -> String {
        let session = try await client.auth.session
        let userId = session.user.id
        let currentEmail = session.user.email ?? ""
        
        var attributes = UserAttributes()
        var needAuthUpdate = false
        
        if let oldPass = oldPassword, !oldPass.isEmpty, let newPass = newPassword, !newPass.isEmpty {
            try await client.auth.signIn(email: currentEmail, password: oldPass)
            attributes.password = newPass
            needAuthUpdate = true
        }
        
        if needAuthUpdate {
            try await client.auth.update(user: attributes)
        }
        
        try await client.database
            .from("users")
            .update([
                "nama": newName
            ])
            .eq("id", value: userId.uuidString)
            .execute()
        
        return newName
    }
    
    func fetchUserScoreAndRank() async throws -> (Int, Int?) {
        let session = try await client.auth.session
        let userId = session.user.id
        
        struct UserScore: Codable { var score: Int; var id: UUID }
        
        let allScores: [UserScore] = try await client.database
            .from("users")
            .select("id, score")
            .neq("role", value: "admin")
            .order("score", ascending: false)
            .execute()
            .value
        
        if let userIndex = allScores.firstIndex(where: { $0.id == userId }) {
            return (allScores[userIndex].score, userIndex + 1)
        }
        return (0, nil)
    }
}
