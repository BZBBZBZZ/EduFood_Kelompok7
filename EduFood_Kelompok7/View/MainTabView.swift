//
//  MainTabView.swift
//  EduFood
//
//  Created by Hendrawan Saputro on 10/05/26.
//

import SwiftUI

struct MainTabView: View {
    // PERBAIKAN DI SINI: Menggunakan @ObservedObject untuk menerima argument
    @ObservedObject var authViewModel: AuthViewModel
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(authViewModel: authViewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Beranda", systemImage: "house.fill")
                }
                .tag(0)
            
            MateriView()
                .tabItem {
                    Label("Materi", systemImage: "book.fill")
                }
                .tag(1)
            
            QuizView()
                .tabItem {
                    Label("Kuis", systemImage: "gamecontroller.fill")
                }
                .tag(2)
            
            LeaderboardView()
                .tabItem {
                    Label("Peringkat", systemImage: "list.number")
                }
                .tag(3)
            
            ProfileView(authViewModel: authViewModel)
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
                .tag(4)
        }
        .accentColor(.blue)
    }
}
