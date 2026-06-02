//
//  AdminDashboardView.swift
//  EduFood_Kelompok7
//
//  Created by Hendrawan Saputro on 29/05/26.
//

import SwiftUI

struct AdminDashboardView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            NavigationView {
                AdminCategoryView()
            }
            .tabItem {
                Label("Kategori", systemImage: "folder.fill")
            }
            
            NavigationView {
                AdminFoodView()
            }
            .tabItem {
                Label("Materi", systemImage: "book.fill")
            }
            
            NavigationView {
                AdminQuizView()
            }
            .tabItem {
                Label("Bank Soal", systemImage: "questionmark.folder.fill")
            }
            
            ProfileView(authViewModel: authViewModel)
                .tabItem {
                    Label("Profil", systemImage: "person.badge.key.fill")
                }
        }
    }
}

#Preview {
    AdminDashboardView(authViewModel: AuthViewModel())
}
