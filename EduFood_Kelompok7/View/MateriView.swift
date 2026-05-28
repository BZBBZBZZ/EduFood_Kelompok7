//
//  MateriView.swift
//  EduFood_Kelompok7
//
//  Created by Nicholas Leroy Kurniawan on 28/05/26.
//

import SwiftUI

struct MateriView: View {
    @StateObject private var viewModel = MateriViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.secondarySystemGroupedBackground)
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Memuat materi gizi...")
                            .foregroundColor(.secondary)
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            Task { await viewModel.fetchMateri() }
                        }) {
                            Text("Coba Lagi")
                                .fontWeight(.bold)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                        }
                    }
                } else if viewModel.foods.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "tray.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("Belum ada materi tersedia.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.foods) { food in
                                NavigationLink(destination: DetailView(food: food)) {
                                    HStack(spacing: 16) {
                                        AsyncImage(url: URL(string: food.imageUrl)) { phase in
                                            if let image = phase.image {
                                                image.resizable().scaledToFill()
                                            } else if phase.error != nil {
                                                Image(systemName: "photo").foregroundColor(.gray)
                                            } else {
                                                ProgressView()
                                            }
                                        }
                                        .frame(width: 80, height: 80)
                                        .background(Color(UIColor.systemGray6))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(food.nama)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            
                                            Text(food.kategori)
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.blue.opacity(0.1))
                                                .foregroundColor(.blue)
                                                .clipShape(Capsule())
                                        }
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                    }
                                    .padding()
                                    .background(Color(UIColor.systemBackground))
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                }
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.fetchMateri()
                    }
                }
            }
            .navigationTitle("Pustaka Materi")
            .task {
                if viewModel.foods.isEmpty {
                    await viewModel.fetchMateri()
                }
            }
        }
    }
}
