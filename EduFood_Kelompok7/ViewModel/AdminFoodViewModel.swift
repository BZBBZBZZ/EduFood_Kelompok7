//
//  AdminFoodViewModel.swift
//  EduFood_Kelompok7
//
//  Created by Hendrawan Saputro on 29/05/26.
//

import Foundation
import PhotosUI
import SwiftUI
import Combine

@MainActor
class AdminFoodViewModel: ObservableObject {
    @Published var foods: [FoodModel] = []
    @Published var categoriesOptions: [String] = ["Sayur", "Buah", "Protein"]
    
    @Published var nama = ""
    @Published var kategori = "Sayur"
    @Published var deskripsi = ""
    @Published var kandunganGizi = ""
    @Published var selectedItem: PhotosPickerItem? = nil
    
    @Published var editingID: UUID? = nil
    @Published var editingImageURL: String? = nil
    
    @Published var isLoading = false
    
    private let foodService: FoodServiceProtocol
    
    init(foodService: FoodServiceProtocol = FoodService()) {
        self.foodService = foodService
    }
    
    func fetchFoods() async {
        do {
            let fetched = try await foodService.fetchFoods()
            self.foods = fetched
        } catch {
            print("Gagal mengambil data food: \(error)")
        }
    }
    
    func fetchCategories() async {
        do {
            let fetchedNames = try await foodService.fetchCategoriesOptions()
            if !fetchedNames.isEmpty {
                self.categoriesOptions = fetchedNames
                if self.kategori.isEmpty || !self.categoriesOptions.contains(self.kategori) {
                    self.kategori = self.categoriesOptions.first ?? "Sayur"
                }
            }
        } catch {
            print("Gagal mengambil kategori untuk form: \(error)")
        }
    }
    
    func saveFood() async {
        isLoading = true
        do {
            var imageData: Data? = nil
            if let item = selectedItem {
                imageData = try await item.loadTransferable(type: Data.self)
            }
            
            try await foodService.saveFood(
                id: editingID,
                nama: nama,
                kategori: kategori,
                deskripsi: deskripsi,
                kandunganGizi: kandunganGizi,
                imageData: imageData,
                existingImageUrl: editingImageURL
            )
            
            clearForm()
            await fetchFoods()
        } catch {
            print("Gagal menyimpan materi: \(error)")
        }
        isLoading = false
    }
    
    func deleteFood(id: UUID) async {
        do {
            try await foodService.deleteFood(id: id)
            await fetchFoods()
        } catch {
            print("Gagal menghapus: \(error)")
        }
    }
    
    func setEditing(food: FoodModel) {
        self.editingID = food.id
        self.nama = food.nama
        self.kategori = food.kategori
        self.deskripsi = food.deskripsi
        self.kandunganGizi = food.kandunganGizi
        self.editingImageURL = food.imageUrl
        self.selectedItem = nil
    }
    
    func clearForm() {
        editingID = nil
        nama = ""
        kategori = "Sayur"
        deskripsi = ""
        kandunganGizi = ""
        editingImageURL = nil
        selectedItem = nil
    }
}
