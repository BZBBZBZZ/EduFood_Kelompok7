//
//  ContentView.swift
//  EduFood_Kelompok7
//
//  Created by Nicholas Leroy Kurniawan on 28/05/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                if authViewModel.userRole == "admin" {
                    AdminDashboardView(authViewModel: authViewModel)
                } else {
                    MainTabView(authViewModel: authViewModel)
                }
            } else {
                LoginView(authViewModel: authViewModel)
            }
        }
        .animation(.default, value: authViewModel.isAuthenticated)
    }
}

#Preview {
    ContentView()
}
