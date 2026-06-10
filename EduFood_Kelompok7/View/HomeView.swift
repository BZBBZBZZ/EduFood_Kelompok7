//  Created by Obie Zuriel on 12/05/26.

import SwiftUI

struct HomeView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.secondarySystemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // User Greeting Header
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Halo,")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                                
                                Text(authViewModel.nama.isEmpty ? "Pelajar" : authViewModel.nama)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        
                        // Current Stats (Centered)
                        HStack(spacing: 16) {
                            StatBoxView(
                                title: "Skor Total",
                                value: "\(authViewModel.score)",
                                icon: "star.fill",
                                color: .yellow
                            )
                            
                            StatBoxView(
                                title: "Peringkat",
                                value: authViewModel.userRank != nil ? "#\(authViewModel.userRank!)" : "-",
                                icon: "trophy.fill",
                                color: .orange
                            )
                        }
                        .padding(.horizontal)
                        
                        
                        // Menu Cards
                        VStack(spacing: 16) {
                            Text("Menu Utama")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            MenuCardView(
                                title: "Mulai Quiz",
                                subtitle: "Uji seberapa tahu kamu tentang gizi",
                                icon: "gamecontroller.fill",
                                color: .blue,
                                isPrimary: true
                            ) {
                                selectedTab = 2
                            }
                            
                            MenuCardView(
                                title: "Materi Makanan",
                                subtitle: "Baca ensiklopedia makanan sehat",
                                icon: "book.fill",
                                color: .green,
                                isPrimary: false
                            ) {
                                selectedTab = 1
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("EduFood")
            .navigationBarHidden(true)
            .task {
                await authViewModel.fetchUserScoreAndRank()
            }
        }
    }
}

struct StatBoxView: View {
    var title: String
    var value: String
    var icon: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 14) {
            
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .padding(12)
                .background(color.opacity(0.15))
                .cornerRadius(14)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(22)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
    }
}

struct MenuCardView: View {
    var title: String
    var subtitle: String
    var icon: String
    var color: Color
    var isPrimary: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(isPrimary ? .white : color)
                    .frame(width: 60, height: 60)
                    .background(isPrimary ? color.opacity(0.3) : color.opacity(0.15))
                    .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(isPrimary ? .white : .primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(isPrimary ? .white.opacity(0.8) : .secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(isPrimary ? .white.opacity(0.8) : .gray)
            }
            .padding()
            .background(isPrimary ? color : Color(UIColor.systemBackground))
            .cornerRadius(20)
            .shadow(
                color: isPrimary
                ? color.opacity(0.3)
                : Color.black.opacity(0.04),
                radius: 8,
                x: 0,
                y: 4
            )
            .padding(.horizontal)
        }
    }
}

#Preview {
    HomeView(authViewModel: AuthViewModel(), selectedTab: .constant(0))
}
