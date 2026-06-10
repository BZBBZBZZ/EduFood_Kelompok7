//  Created by Obie Zuriel on 12/05/26.

import Foundation
import Supabase

protocol LeaderboardServiceProtocol {
    func fetchLeaderboard() async throws -> [RankModel]
}

class LeaderboardService: LeaderboardServiceProtocol {
    let client = SupabaseService.shared.client
    
    func fetchLeaderboard() async throws -> [RankModel] {
        return try await client.database
            .from("users")
            .select("id, nama, score")
            .neq("role", value: "admin")
            .order("score", ascending: false)
            .limit(50)
            .execute()
            .value
    }
}
