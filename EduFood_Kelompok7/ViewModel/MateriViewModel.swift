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
    
    private let foodService: FoodServiceProtocol
    
    init(foodService: FoodServiceProtocol = FoodService()) {
        self.foodService = foodService
    }
    
    func fetchMateri() async {
        self.errorMessage = nil
        self.isLoading = true
        
        do {
            let fetchedFoods = try await foodService.fetchFoods()
            
            self.foods = fetchedFoods
            self.isLoading = false 
            
        } catch is CancellationError {
            print("Fetch dibatalkan oleh sistem SwiftUI. Diabaikan.")
            self.isLoading = false
            
        } catch {
            self.errorMessage = "Gagal memuat data: \(error.localizedDescription)"
            self.isLoading = false
            print("Fetch Error: \(error)")
        }
    }
}

