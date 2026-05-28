//
//  FoodModel.swift
//  EduFood_Kelompok7
//
//  Created by Nicholas Leroy Kurniawan on 28/05/26.
//

import Foundation

struct FoodModel: Identifiable, Codable {
    var id: UUID
    var nama: String
    var kategori: String
    var deskripsi: String
    var kandunganGizi: String
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case nama
        case kategori
        case deskripsi
        case kandunganGizi = "kandungan_gizi"
        case imageUrl = "image_url"
    }
}
