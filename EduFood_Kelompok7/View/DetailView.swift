//
//  DetailView.swift
//  EduFood_Kelompok7
//
//  Created by Nicholas Leroy Kurniawan on 28/05/26.
//


import SwiftUI

struct DetailView: View {
    var food: FoodModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Image
                AsyncImage(url: URL(string: food.imageUrl)) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 300)
                            .clipped()
                    } else if phase.error != nil {
                        Rectangle()
                            .fill(Color(UIColor.secondarySystemBackground))
                            .frame(height: 300)
                            .overlay(Image(systemName: "photo").font(.largeTitle).foregroundColor(.gray))
                    } else {
                        Rectangle()
                            .fill(Color(UIColor.secondarySystemBackground))
                            .frame(height: 300)
                            .overlay(ProgressView())
                    }
                }
                
                // Content
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(food.kategori.uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Capsule())
                            Spacer()
                        }
                        
                        Text(food.nama)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    
                    Divider()
                    
                    // Description Section
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Deskripsi", systemImage: "text.alignleft")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(food.deskripsi)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    
                    Divider()
                    
                    // Nutrition Section
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Kandungan Gizi & Manfaat", systemImage: "heart.text.square.fill")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(food.kandunganGizi)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    
                    Spacer()
                }
                .padding(24)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(24)
                .offset(y: -24)
                .padding(.bottom, -24)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
    }
}
