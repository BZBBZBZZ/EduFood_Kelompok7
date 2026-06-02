//
//  AdminQuizView.swift
//  EduFood_Kelompok7
//
//  Created by Hendrawan Saputro on 29/05/26.
//

import SwiftUI

struct AdminQuizView: View {
    @StateObject private var viewModel = AdminQuizViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Form Section
                VStack(spacing: 16) {
                    Text(viewModel.editingID == nil ? "Tambah Soal Baru" : "Edit Soal")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextEditor(text: $viewModel.pertanyaan)
                        .frame(height: 80)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                        .overlay(Text("Pertanyaan").foregroundColor(.gray).opacity(viewModel.pertanyaan.isEmpty ? 1 : 0).padding(.top, 8).padding(.leading, 5), alignment: .topLeading)
                    
                    VStack(spacing: 10) {
                        TextField("Opsi A", text: $viewModel.opsiA).textFieldStyle(.roundedBorder)
                        TextField("Opsi B", text: $viewModel.opsiB).textFieldStyle(.roundedBorder)
                        TextField("Opsi C", text: $viewModel.opsiC).textFieldStyle(.roundedBorder)
                        TextField("Opsi D", text: $viewModel.opsiD).textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text("Kunci Jawaban:")
                        Spacer()
                        Picker("Kunci Jawaban", selection: $viewModel.kunciJawaban) {
                            Text("A").tag("A")
                            Text("B").tag("B")
                            Text("C").tag("C")
                            Text("D").tag("D")
                        }.pickerStyle(.segmented)
                    }
                    
                    TextEditor(text: $viewModel.pembahasan)
                        .frame(height: 80)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                        .overlay(Text("Pembahasan (Alasan Jawaban Benar)").foregroundColor(.gray).opacity(viewModel.pembahasan.isEmpty ? 1 : 0).padding(.top, 8).padding(.leading, 5), alignment: .topLeading)
                    
                    HStack {
                        if viewModel.editingID != nil {
                            Button("Batal") {
                                viewModel.clearForm()
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.red)
                        }
                        
                        Button(action: {
                            Task { await viewModel.saveQuizQuestion() }
                        }) {
                            if viewModel.isLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Simpan")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // List Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Daftar Soal")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(viewModel.questions) { q in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(q.pertanyaan).font(.subheadline).lineLimit(2)
                                Text("Kunci: \(q.kunciJawaban)").font(.caption).foregroundColor(.green)
                            }
                            Spacer()
                            Button {
                                viewModel.setEditing(q: q)
                            } label: {
                                Image(systemName: "pencil.circle.fill").foregroundColor(.blue).font(.title2)
                            }
                            Button {
                                Task { await viewModel.deleteQuestion(id: q.id) }
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
        .navigationTitle("Kelola Kuis")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Pemberitahuan"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .task {
            await viewModel.fetchQuestions()
        }
    }
}

#Preview {
    NavigationView {
        AdminQuizView()
    }
}
