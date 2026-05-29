//
//  AdminCategoryViewModel.swift
//  EduFood_Kelompok7
//
//  Created by Hendrawan Saputro on 29/05/26.
//

import Foundation
import Combine

@MainActor
class AdminCategoryViewModel: ObservableObject {
    @Published var categories: [CategoryModel] = []
    @Published var name = ""
    @Published var editingID: UUID? = nil
    @Published var isLoading = false
    @Published var alertMessage = ""
    @Published var showAlert = false
    
    private let categoryService: CategoryServiceProtocol
    
    init(categoryService: CategoryServiceProtocol = CategoryService()) {
        self.categoryService = categoryService
    }
    
    func fetchCategories() async {
        do {
            let fetched = try await categoryService.fetchCategories()
            self.categories = fetched
        } catch is CancellationError {
            // SOLUSI: Abaikan error jika tugas dibatalkan oleh transisi layar SwiftUI
            print("Fetch kategori dibatalkan oleh sistem SwiftUI. Diabaikan.")
        } catch {
            print("Gagal mengambil data kategori: \(error)")
            self.alertMessage = "Gagal mengambil data: \(error.localizedDescription)"
            self.showAlert = true
        }
    }
    
    func saveCategory() async {
        guard !name.isEmpty else { return }
        isLoading = true
        do {
            try await categoryService.saveCategory(id: editingID, name: name)
            self.alertMessage = editingID != nil ? "Kategori berhasil diupdate!" : "Kategori berhasil ditambahkan!"
            self.showAlert = true
            clearForm()
            await fetchCategories()
        } catch {
            print("Gagal menyimpan kategori: \(error)")
            self.alertMessage = "Gagal menyimpan: \(error.localizedDescription)"
            self.showAlert = true
        }
        isLoading = false
    }
    
    func deleteCategory(id: UUID) async {
        do {
            try await categoryService.deleteCategory(id: id)
            await fetchCategories()
            self.alertMessage = "Kategori dihapus."
            self.showAlert = true
        } catch {
            print("Gagal menghapus kategori: \(error)")
            self.alertMessage = "Gagal menghapus: \(error.localizedDescription)"
            self.showAlert = true
        }
    }
    
    func setEditing(category: CategoryModel) {
        self.editingID = category.id
        self.name = category.name
    }
    
    func clearForm() {
        editingID = nil
        name = ""
    }
}
