//
//  QuizView.swift
//  EduFood_Kelompok7
//
//  Created by Dave on 29/05/26.
//

import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel = QuizViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.secondarySystemGroupedBackground)
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView("Menyiapkan Kuis...")
                        .scaleEffect(1.2)
                } else if !viewModel.hasStarted {
                    // Pre-quiz screen
                    VStack(spacing: 30) {
                        Image(systemName: "gamecontroller.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                        
                        Text("Kuis Pengetahuan Gizi")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Uji pemahamanmu tentang makanan sehat!\nKamu punya 10 detik untuk setiap pertanyaan.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        Button(action: {
                            viewModel.startQuiz()
                        }) {
                            Text("Mulai Kuis")
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(16)
                                .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .padding(.horizontal, 40)
                        .disabled(viewModel.questions.isEmpty)
                    }
                } else if viewModel.isQuizFinished {
                    ResultView(score: viewModel.score, answers: viewModel.quizAnswers) {
                        viewModel.restartQuiz()
                    }
                } else if !viewModel.questions.isEmpty {
                    // Active quiz screen
                    let currentQ = viewModel.questions[viewModel.currentQuestionIndex]
                    
                    VStack {
                        HStack {
                            Text("Soal \(viewModel.currentQuestionIndex + 1)/\(viewModel.questions.count)")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("00:\(String(format: "%02d", viewModel.timeRemaining))")
                                .font(.headline)
                                .foregroundColor(viewModel.timeRemaining <= 3 ? .red : .primary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(UIColor.systemBackground))
                                .cornerRadius(8)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                        }
                        .padding()
                        
                        ProgressView(value: Double(viewModel.currentQuestionIndex), total: Double(viewModel.questions.count))
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        
                        VStack(spacing: 20) {
                            Text(currentQ.pertanyaan)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.systemBackground))
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            
                            VStack(spacing: 12) {
                                OptionButton(text: currentQ.opsiA, optionLetter: "A") { viewModel.submitAnswer("A") }
                                OptionButton(text: currentQ.opsiB, optionLetter: "B") { viewModel.submitAnswer("B") }
                                OptionButton(text: currentQ.opsiC, optionLetter: "C") { viewModel.submitAnswer("C") }
                                OptionButton(text: currentQ.opsiD, optionLetter: "D") { viewModel.submitAnswer("D") }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Batal") {
                                viewModel.cancelQuiz()
                            }
                            .foregroundColor(.red)
                        }
                    }
                } else {
                    Text("Belum ada soal yang tersedia.")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle(viewModel.hasStarted && !viewModel.isQuizFinished ? "" : "Kuis")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            if viewModel.questions.isEmpty {
                await viewModel.fetchQuestions()
            }
        }
    }
}

struct OptionButton: View {
    var text: String
    var optionLetter: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(optionLetter)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.blue)
                    .clipShape(Circle())
                
                Text(text)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 8)
                
                Spacer()
            }
            .padding(12)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        }
    }
}

#Preview {
    QuizView()
}
