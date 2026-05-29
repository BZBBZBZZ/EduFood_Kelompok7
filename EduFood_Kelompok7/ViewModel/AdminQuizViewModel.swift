//
//  AdminQuizViewModel.swift
//  EduFood_Kelompok7
//
//  Created by Hendrawan Saputro on 29/05/26.
//

import SwiftUI
import Combine

@MainActor
class AdminQuizViewModel: ObservableObject {
    @Published var questions: [QuestionModel] = []
    
    @Published var pertanyaan = ""
    @Published var opsiA = ""
    @Published var opsiB = ""
    @Published var opsiC = ""
    @Published var opsiD = ""
    @Published var kunciJawaban = "A"
    @Published var pembahasan = ""
    
    @Published var editingID: UUID? = nil
    
    @Published var isLoading = false
    @Published var alertMessage = ""
    @Published var showAlert = false
    
    private let quizService: QuizServiceProtocol
    
    init(quizService: QuizServiceProtocol = QuizService()) {
        self.quizService = quizService
    }
    
    func fetchQuestions() async {
        do {
            let fetched = try await quizService.fetchQuestions()
            self.questions = fetched
        } catch {
            print("Gagal mengambil data soal: \(error)")
        }
    }
    
    func saveQuizQuestion() async {
        guard !pertanyaan.isEmpty, !opsiA.isEmpty, !opsiB.isEmpty, !opsiC.isEmpty, !opsiD.isEmpty, !pembahasan.isEmpty else {
            alertMessage = "Semua kolom harus diisi!"
            showAlert = true
            return
        }
        
        isLoading = true
        let questionData = [
            "pertanyaan": pertanyaan,
            "opsi_a": opsiA,
            "opsi_b": opsiB,
            "opsi_c": opsiC,
            "opsi_d": opsiD,
            "kunci_jawaban": kunciJawaban,
            "pembahasan": pembahasan
        ]
        
        do {
            try await quizService.saveQuizQuestion(id: editingID, questionData: questionData)
            alertMessage = editingID != nil ? "Soal berhasil diupdate!" : "Soal berhasil ditambahkan!"
            showAlert = true
            clearForm()
            await fetchQuestions()
        } catch {
            alertMessage = "Gagal menyimpan soal: \(error.localizedDescription)"
            showAlert = true
        }
        isLoading = false
    }
    
    func deleteQuestion(id: UUID) async {
        do {
            try await quizService.deleteQuestion(id: id)
            await fetchQuestions()
        } catch {
            print("Gagal menghapus soal: \(error)")
        }
    }
    
    func setEditing(q: QuestionModel) {
        self.editingID = q.id
        self.pertanyaan = q.pertanyaan
        self.opsiA = q.opsiA
        self.opsiB = q.opsiB
        self.opsiC = q.opsiC
        self.opsiD = q.opsiD
        self.kunciJawaban = q.kunciJawaban
        self.pembahasan = q.pembahasan
    }
    
    func clearForm() {
        editingID = nil
        pertanyaan = ""; opsiA = ""; opsiB = ""; opsiC = ""; opsiD = ""; pembahasan = ""; kunciJawaban = "A"
    }
}
