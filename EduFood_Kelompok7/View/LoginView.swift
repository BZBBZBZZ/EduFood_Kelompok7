//  Created by Obie Zuriel on 12/05/26.

import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var isRegistering = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Logo & Greeting
                    VStack(spacing: 12) {
                        Image(systemName: "leaf.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.green)
                            .padding()
                            .background(Circle().fill(Color.green.opacity(0.1)))
                        
                        Text("EduFood")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Mulai gaya hidup sehatmu sekarang.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Form Fields
                    VStack(spacing: 16) {
                        TextField("Email", text: $authViewModel.email)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(12)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                        SecureField("Kata Sandi", text: $authViewModel.password)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.horizontal, 24)
                    }
                    
                    // Buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            Task {
                                await authViewModel.signIn()
                            }
                        }) {
                            HStack {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Masuk")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .disabled(authViewModel.isLoading || authViewModel.email.isEmpty || authViewModel.password.isEmpty)
                        .padding(.horizontal, 24)
                        
                        HStack(spacing: 4) {
                            Text("Belum punya akun?")
                                .foregroundColor(.secondary)
                            Button(action: { isRegistering = true }) {
                                Text("Daftar Sekarang")
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                        }
                        .font(.subheadline)
                        .padding(.top, 8)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $isRegistering) {
                RegisterView(authViewModel: authViewModel)
            }
        }
    }
}

#Preview {
    LoginView(authViewModel: AuthViewModel())
}
