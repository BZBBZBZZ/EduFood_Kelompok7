//
//  MateriViewModel.swift
//  EduFood_Kelompok7
//
//  Created by Nicholas Leroy Kurniawan on 28/05/26.
//

import Foundation
import Combine

@MainActor
class MateriViewModel: ObservableObject {
    @Published var foods: [FoodModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Inisialisasi Service
    private let foodService: FoodServiceProtocol
    
    init(foodService: FoodServiceProtocol = FoodService()) {
        self.foodService = foodService
    }
    
    func fetchMateri() async {
        // 1. Reset error message setiap kali fungsi dipanggil (penting untuk tombol Coba Lagi)
        self.errorMessage = nil
        self.isLoading = true
        
        do {
            // Mengambil data
            let fetchedFoods = try await foodService.fetchFoods()
            
            self.foods = fetchedFoods
            self.isLoading = false // Matikan loading jika sukses
            
        } catch is CancellationError {
            // 2. SOLUSI: Abaikan error jika tugas dibatalkan oleh transisi UI SwiftUI
            print("Fetch dibatalkan oleh sistem SwiftUI. Diabaikan.")
            self.isLoading = false
            
        } catch {
            // Tangkap error lainnya (seperti internet mati atau RLS)
            self.errorMessage = "Gagal memuat data: \(error.localizedDescription)"
            self.isLoading = false
            print("Fetch Error: \(error)")
        }
    }
}

