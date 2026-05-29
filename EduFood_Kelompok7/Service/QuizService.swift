//
//  QuizService.swift
//  EduFood_Kelompok7
//
//  Created by Dave on 29/05/26.
//

import Foundation
import Supabase

protocol QuizServiceProtocol {
    func fetchQuestions() async throws -> [QuestionModel]
    func saveQuizQuestion(id: UUID?, questionData: [String: String]) async throws
    func deleteQuestion(id: UUID) async throws
    func saveHighScore(newScore: Int) async throws
}

class QuizService: QuizServiceProtocol {
    let client = SupabaseService.shared.client
    
    func fetchQuestions() async throws -> [QuestionModel] {
        return try await client.database
            .from("quiz_questions")
            .select()
            .execute()
            .value
    }
    
    func saveQuizQuestion(id: UUID?, questionData: [String: String]) async throws {
        if let id = id {
            struct UpdatePayload: Codable {
                var pertanyaan: String?
                var opsi_a: String?
                var opsi_b: String?
                var opsi_c: String?
                var opsi_d: String?
                var kunci_jawaban: String?
                var pembahasan: String?
            }
            try await client.database
                .from("quiz_questions")
                .update(questionData)
                .eq("id", value: id)
                .execute()
        } else {
            try await client.database
                .from("quiz_questions")
                .insert(questionData)
                .execute()
        }
    }
    
    func deleteQuestion(id: UUID) async throws {
        try await client.database
            .from("quiz_questions")
            .delete()
            .eq("id", value: id)
            .execute()
    }
    
    func saveHighScore(newScore: Int) async throws {
        let session = try await client.auth.session
        let userId = session.user.id
        
        struct CurrentUserScore: Codable {
            var score: Int
        }
        
        let currentUserData: CurrentUserScore = try await client.database
            .from("users")
            .select("score")
            .eq("id", value: userId)
            .single()
            .execute()
            .value
        
        if newScore > currentUserData.score {
            try await client.database
                .from("users")
                .update(["score": newScore])
                .eq("id", value: userId)
                .execute()
        }
    }
}

