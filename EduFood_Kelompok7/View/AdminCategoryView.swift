//
//  AdminCategoryView.swift
//  EduFood_Kelompok7
//
//  Created by Hendrawan Saputro on 29/05/26.
//

import SwiftUI

struct AdminCategoryView: View {
    @StateObject private var viewModel = AdminCategoryViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Form Section
                VStack(spacing: 16) {
                    Text(viewModel.editingID == nil ? "Tambah Kategori Baru" : "Edit Kategori")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("Nama Kategori", text: $viewModel.name)
                        .textFieldStyle(.roundedBorder)
                    
                    HStack {
                        if viewModel.editingID != nil {
                            Button("Batal") {
                                viewModel.clearForm()
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.red)
                        }
                        
                        Button(action: {
                            Task { await viewModel.saveCategory() }
                        }) {
                            if viewModel.isLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Simpan")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                        .disabled(viewModel.name.isEmpty)
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // List Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Daftar Kategori")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(viewModel.categories) { cat in
                        HStack {
                            Text(cat.name).font(.headline)
                            Spacer()
                            Button {
                                viewModel.setEditing(category: cat)
                            } label: {
                                Image(systemName: "pencil.circle.fill").foregroundColor(.blue).font(.title2)
                            }
                            Button {
                                Task { await viewModel.deleteCategory(id: cat.id) }
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
        .navigationTitle("Kelola Kategori")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Pemberitahuan"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .task {
            await viewModel.fetchCategories()
        }
    }
}
