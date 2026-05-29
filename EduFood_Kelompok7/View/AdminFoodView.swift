//
//  AdminFoodView.swift
//  EduFood_Kelompok7
//
//  Created by Hendrawan Saputro on 29/05/26.
//

import SwiftUI
import PhotosUI

struct AdminFoodView: View {
    @StateObject private var viewModel = AdminFoodViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Form Section
                VStack(spacing: 16) {
                    Text(viewModel.editingID == nil ? "Tambah Materi Baru" : "Edit Materi")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("Nama Makanan", text: $viewModel.nama)
                        .textFieldStyle(.roundedBorder)
                    
                    Picker("Kategori", selection: $viewModel.kategori) {
                        ForEach(viewModel.categoriesOptions, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    .pickerStyle(.menu) // Menggunakan menu agar pas apabila ada banyak kategori
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(8)
                    
                    PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                        Label(viewModel.selectedItem == nil && viewModel.editingImageURL == nil ? "Pilih Gambar" : "Ganti Gambar", systemImage: "photo")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                    }
                    
                    TextEditor(text: $viewModel.deskripsi)
                        .frame(height: 80)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                        .overlay(
                            Text("Deskripsi").foregroundColor(.gray).opacity(viewModel.deskripsi.isEmpty ? 1 : 0).padding(.top, 8).padding(.leading, 5),
                            alignment: .topLeading
                        )
                    
                    TextEditor(text: $viewModel.kandunganGizi)
                        .frame(height: 80)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                        .overlay(
                            Text("Kandungan Gizi").foregroundColor(.gray).opacity(viewModel.kandunganGizi.isEmpty ? 1 : 0).padding(.top, 8).padding(.leading, 5),
                            alignment: .topLeading
                        )
                    
                    HStack {
                        if viewModel.editingID != nil {
                            Button("Batal") {
                                viewModel.clearForm()
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.red)
                        }
                        
                        Button(action: {
                            Task { await viewModel.saveFood() }
                        }) {
                            if viewModel.isLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Simpan")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                        .disabled(viewModel.nama.isEmpty)
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // List Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Daftar Materi")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(viewModel.foods) { food in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(food.nama).font(.headline)
                                Text(food.kategori).font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            Button {
                                viewModel.setEditing(food: food)
                            } label: {
                                Image(systemName: "pencil.circle.fill").foregroundColor(.blue).font(.title2)
                            }
                            Button {
                                Task { await viewModel.deleteFood(id: food.id) }
                            } label: {
                                Image(systemName: "trash.circle.fill").foregroundColor(.red).font(.title2)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 3)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(UIColor.secondarySystemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Kelola Makanan")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchCategories()
            await viewModel.fetchFoods()
        }
    }
}
