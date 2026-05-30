//
//  AuthViewModel.swift
//  EduFood
//
//  Created by Hendrawan Saputro on 10/05/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var nama = ""
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var userRole: String = "user"
    @Published var score: Int = 0
    @Published var userRank: Int? = nil
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    func signUp() async {
        isLoading = true
        errorMessage = nil
        do {
            try await authService.signUp(email: email, password: password, nama: nama)
            self.isAuthenticated = true
        } catch {
            self.errorMessage = "Pendaftaran gagal: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func signIn() async {
        isLoading = true
        errorMessage = nil
        do {
            let user = try await authService.signIn(email: email, password: password)
            self.userRole = user.role
            self.nama = user.nama
            self.isAuthenticated = true
        } catch {
            self.errorMessage = "Email atau kata sandi salah"
        }
        isLoading = false
    }
    
    func signOut() async {
        try? await authService.signOut()
        self.isAuthenticated = false
        self.email = ""
        self.password = ""
        self.nama = ""
        self.userRole = "user"
        self.score = 0
        self.userRank = nil
    }
    
    func updateProfile(newName: String, newEmail: String, oldPassword: String?, newPassword: String?) async -> Bool {
        self.isLoading = true
        self.errorMessage = nil
        
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.@_-")
        let cleanEmail = String(newEmail.unicodeScalars.filter { allowedCharacterSet.contains($0) }).lowercased()
        
        do {
            let updatedData = try await authService.updateProfile(
                newName: newName,
                newEmail: cleanEmail,
                oldPassword: oldPassword,
                newPassword: newPassword
            )
            
            await MainActor.run {
                self.nama = updatedData.0
                if !cleanEmail.isEmpty { self.email = updatedData.1 }
                self.isLoading = false
            }
            return true
            
        } catch {
            print("❌ ERROR TERJADI SAAT UPDATE PROFIL:")
            print(error)
            
            await MainActor.run {
                if error.localizedDescription.contains("rate limit") {
                    self.errorMessage = "Terlalu banyak mencoba. Tunggu beberapa saat lagi."
                } else if error.localizedDescription.contains("already registered") {
                    self.errorMessage = "Email ini sudah digunakan oleh akun lain."
                } else {
                    self.errorMessage = "Gagal memperbarui profil: \(error.localizedDescription)"
                }
                self.isLoading = false
            }
            return false
        }
    }
    
    func fetchUserScoreAndRank() async {
        do {
            let userScoreAndRank = try await authService.fetchUserScoreAndRank()
            self.score = userScoreAndRank.0
            self.userRank = userScoreAndRank.1
        } catch {
            print("Gagal mendapatkan score/rank: \(error)")
        }
    }
}
