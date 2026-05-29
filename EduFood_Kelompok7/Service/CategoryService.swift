//
//  CategoryService.swift
//  EduFood_Kelompok7
//
//  Created by Hendrawan Saputro on 29/05/26.
//

import Foundation
import Supabase

protocol CategoryServiceProtocol {
    func fetchCategories() async throws -> [CategoryModel]
    func saveCategory(id: UUID?, name: String) async throws
    func deleteCategory(id: UUID) async throws
}

class CategoryService: CategoryServiceProtocol {
    let client = SupabaseService.shared.client
    
    func fetchCategories() async throws -> [CategoryModel] {
        return try await client.database
            .from("categories")
            .select()
            .execute()
            .value
    }
    
    func saveCategory(id: UUID?, name: String) async throws {
        if let id = id {
            struct UpdateCategory: Codable { var name: String }
            try await client.database
                .from("categories")
                .update(UpdateCategory(name: name))
                .eq("id", value: id)
                .execute()
        } else {
            let newCategory = CategoryModel(id: UUID(), name: name)
            try await client.database
                .from("categories")
                .insert(newCategory)
                .execute()
        }
    }
    
    func deleteCategory(id: UUID) async throws {
        try await client.database
            .from("categories")
            .delete()
            .eq("id", value: id)
            .execute()
    }
}
