//
//  LeaderboardViewModel.swift
//  EduFood
//
//  Created by Obie Zuriel on 12/05/26.
//

import Foundation
import Combine

@MainActor
class LeaderboardViewModel: ObservableObject {
    @Published var topUsers: [RankModel] = []
    
    private let leaderboardService: LeaderboardServiceProtocol
    
    init(leaderboardService: LeaderboardServiceProtocol = LeaderboardService()) {
        self.leaderboardService = leaderboardService
    }
    
    func fetchLeaderboard() async {
        do {
            // Mengambil Top 50 Users, diurutkan dari skor tertinggi (descending)
            let fetchedUsers = try await leaderboardService.fetchLeaderboard()
            
            self.topUsers = fetchedUsers
        } catch {
            print("Gagal memuat papan peringkat: \(error)")
        }
    }
}
