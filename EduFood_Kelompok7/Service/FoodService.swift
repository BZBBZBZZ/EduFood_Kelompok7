//
//  FoodService.swift
//  EduFood_Kelompok7
//
//  Created by Nicholas Leroy Kurniawan on 28/05/26.
//

import Foundation
import Supabase

protocol FoodServiceProtocol {
    func fetchFoods() async throws -> [FoodModel]
    func fetchCategoriesOptions() async throws -> [String]
    func saveFood(id: UUID?, nama: String, kategori: String, deskripsi: String, kandunganGizi: String, imageData: Data?, existingImageUrl: String?) async throws
    func deleteFood(id: UUID) async throws
}

class FoodService: FoodServiceProtocol {
    let client = SupabaseService.shared.client
    
    func fetchFoods() async throws -> [FoodModel] {
        return try await client
            .from("foods")
            .select()
            .execute()
            .value
    }
    
    func fetchCategoriesOptions() async throws -> [String] {
        struct CatOpt: Codable { var name: String }
        let fetched: [CatOpt] = try await client
            .from("categories")
            .select("name")
            .execute()
            .value
        return fetched.map { $0.name }
    }
    
    func saveFood(id: UUID?, nama: String, kategori: String, deskripsi: String, kandunganGizi: String, imageData: Data?, existingImageUrl: String?) async throws {
        var imageUrl = existingImageUrl
        
        if let data = imageData {
            let fileName = "\(UUID().uuidString).jpg"
            try await client.storage
                .from("food-images")
                .upload(fileName, data: data)
            
            imageUrl = try client.storage.from("food-images").getPublicURL(path: fileName).absoluteString
        }
        
        if let id = id {
            let updateData = [
                "nama": nama,
                "kategori": kategori,
                "deskripsi": deskripsi,
                "kandungan_gizi": kandunganGizi,
                "image_url": imageUrl ?? ""
            ]
            try await client
                .from("foods")
                .update(updateData)
                .eq("id", value: id)
                .execute()
        } else {
            let newFood = [
                "nama": nama,
                "kategori": kategori,
                "deskripsi": deskripsi,
                "kandungan_gizi": kandunganGizi,
                "image_url": imageUrl ?? ""
            ]
            try await client
                .from("foods")
                .insert(newFood)
                .execute()
        }
    }
    
    func deleteFood(id: UUID) async throws {
        try await client
            .from("foods")
            .delete()
            .eq("id", value: id)
            .execute()
    }
}
