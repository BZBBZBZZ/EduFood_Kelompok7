//
//  ResultView.swift
//  EduFood_Kelompok7
//
//  Created by Dave on 29/05/26.
//

import SwiftUI

struct ResultView: View {
    var score: Int
    var answers: [QuizAnswer]
    var onRestart: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Score Card
                VStack(spacing: 16) {
                    Image(systemName: score >= 80 ? "medal.fill" : "hand.thumbsup.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(score >= 80 ? .yellow : .blue)
                        .padding(.top, 20)
                    
                    Text("Skor Akhir")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("\(score)")
                        .font(.system(size: 60, weight: .black, design: .rounded))
                    
                    Text(score >= 80 ? "Luar Biasa! Pemahaman gizimu hebat." : "Bagus! Mari tingkatkan lagi.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                .padding(.horizontal)
                .padding(.top, 20)
                
                Button(action: onRestart) {
                    Text("Ulangi Kuis")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(16)
                }
                .padding(.horizontal)
                
                // Review Section
                if !answers.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Review Pembahasan")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ForEach(Array(answers.enumerated()), id: \.element.id) { index, answer in
                            ReviewCard(index: index + 1, answer: answer)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color(UIColor.secondarySystemGroupedBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}

struct ReviewCard: View {
    var index: Int
    var answer: QuizAnswer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text("\(index).")
                    .fontWeight(.bold)
                Text(answer.question.pertanyaan)
                    .fontWeight(.semibold)
            }
            
            Divider()
            
            HStack {
                Text("Jawaban Anda:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(answer.selectedOption ?? "Tidak dijawab")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(answer.isCorrect ? .green : .red)
                
                Image(systemName: answer.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(answer.isCorrect ? .green : .red)
            }
            
            HStack {
                Text("Kunci Jawaban:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(answer.question.kunciJawaban)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Pembahasan:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text(answer.question.pembahasan)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.blue.opacity(0.05))
            .cornerRadius(10)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}


#Preview {
    NavigationView {
        ResultView(
            score: 80,
            answers: [
                QuizAnswer(
                    question: QuestionModel(
                        id: UUID(),
                        pertanyaan: "Manakah yang merupakan sumber vitamin C terbaik?",
                        opsiA: "Jeruk",
                        opsiB: "Nasi",
                        opsiC: "Roti",
                        opsiD: "Mie",
                        kunciJawaban: "A",
                        pembahasan: "Jeruk mengandung vitamin C yang sangat tinggi."
                    ),
                    selectedOption: "A",
                    isCorrect: true
                )
            ],
            onRestart: {}
        )
    }
}
