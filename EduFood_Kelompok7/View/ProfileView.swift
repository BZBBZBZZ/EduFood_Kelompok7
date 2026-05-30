import SwiftUI

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    // Variabel State lokal untuk memperbaiki bug input
    @State private var editNama: String = ""
    @State private var editEmail: String = ""
    @State private var oldPassword: String = "" // Tambahan untuk konfirmasi sandi lama
    @State private var editPassword: String = ""
    
    @State private var isEditing = false
    @State private var showingLogoutAlert = false
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                // Section 1: Informasi Tampilan
                Section(header: Text("Informasi Akun")) {
                    if isEditing {
                        TextField("Nama Lengkap", text: $editNama)
                            .disableAutocorrection(true)
                        
                        TextField("Email Baru", text: $editEmail)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.emailAddress)
                        
                        // Kolom sandi lama diperlukan oleh ViewModel jika ingin ganti sandi baru
                        SecureField("Kata Sandi Lama (Wajib jika ganti sandi)", text: $oldPassword)
                        SecureField("Kata Sandi Baru", text: $editPassword)
                    } else {
                        HStack {
                            Text("Nama")
                            Spacer()
                            Text(authViewModel.nama)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(authViewModel.email)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Status")
                            Spacer()
                            Text(authViewModel.userRole.capitalized)
                                .foregroundColor(.blue)
                                .bold()
                        }
                    }
                }
                
                // Menampilkan error jika ada masalah saat update
                if isEditing, let errorMessage = authViewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                // Section 2: Tombol Aksi
                Section {
                    if isEditing {
                        Button(action: {
                            Task {
                                await handleUpdate()
                            }
                        }) {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                            } else {
                                Text("Simpan Perubahan")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .disabled(authViewModel.isLoading)
                        
                        Button("Batal") {
                            isEditing = false
                            resetLocalFields()
                            authViewModel.errorMessage = nil
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                    } else {
                        Button("Edit Profil") {
                            prepareFields()
                            isEditing = true
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                // Section 3: Logout
                Section {
                    Button(role: .destructive) {
                        showingLogoutAlert = true
                    } label: {
                        Label("Keluar dari Aplikasi", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Profil")
            .onAppear {
                prepareFields()
            }
            // Alert untuk Logout
            .alert("Konfirmasi Keluar", isPresented: $showingLogoutAlert) {
                Button("Batal", role: .cancel) { }
                Button("Keluar", role: .destructive) {
                    Task {
                        await authViewModel.signOut()
                    }
                }
            } message: {
                Text("Apakah Anda yakin ingin keluar dari akun Edufood?")
            }
            // Alert Sukses Update
            .alert("Berhasil", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Profil Anda telah diperbarui.")
            }
        }
    }
    
    // Fungsi untuk memindahkan data dari ViewModel ke State Lokal
    private func prepareFields() {
        editNama = authViewModel.nama
        editEmail = authViewModel.email
        resetLocalFields()
    }
    
    // Membersihkan kolom sandi
    private func resetLocalFields() {
        oldPassword = ""
        editPassword = ""
    }
    
    // Fungsi untuk memicu update di AuthViewModel
    private func handleUpdate() async {
        // PERBAIKAN: Menggunakan parameter newName dan oldPassword sesuai AuthViewModel
        let success = await authViewModel.updateProfile(
            newName: editNama,
            newEmail: editEmail,
            oldPassword: oldPassword.isEmpty ? nil : oldPassword,
            newPassword: editPassword.isEmpty ? nil : editPassword
        )
        
        if success {
            isEditing = false
            showSuccessAlert = true
            resetLocalFields()
        }
    }
}
