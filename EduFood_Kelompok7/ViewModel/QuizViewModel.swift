//
//  QuizViewModel.swift
//  EduFood_Kelompok7
//
//  Created by Dave on 29/05/26.
//

import Foundation
import Combine


struct QuizAnswer: Identifiable {
    let id = UUID()
    let question: QuestionModel
    let selectedOption: String?
    let isCorrect: Bool
}

@MainActor
class QuizViewModel: ObservableObject {
    @Published var questions: [QuestionModel] = []
    @Published var currentQuestionIndex = 0
    @Published var score = 0
    @Published var timeRemaining = 10
    @Published var isQuizFinished = false
    @Published var isLoading = false
    @Published var hasStarted = false
    @Published var quizAnswers: [QuizAnswer] = []
    
    
    
    private var timerSubscription: AnyCancellable?
    
    private let quizService: QuizServiceProtocol
    
    init(quizService: QuizServiceProtocol = QuizService()) {
        self.quizService = quizService
    }
    
    func fetchQuestions() async {
        isLoading = true
        do {
            let fetchedQuestions = try await quizService.fetchQuestions()
            
            self.questions = fetchedQuestions.shuffled()
            self.isLoading = false
        } catch {
            print("Error fetching questions: \(error)")
            self.isLoading = false
        }
    }
    
    func startQuiz() {
        self.score = 0
        self.currentQuestionIndex = 0
        self.isQuizFinished = false
        self.quizAnswers = []
        self.hasStarted = true
        startTimer()
    }
    
    func startTimer() {
        timeRemaining = 10
        timerSubscription?.cancel()
        timerSubscription = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.submitAnswer(nil)
                }
            }
    }
    
    func submitAnswer(_ selectedOption: String?) {
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = selectedOption == currentQuestion.kunciJawaban
        
        if isCorrect {
            score += 10
        }
        
        quizAnswers.append(QuizAnswer(
            question: currentQuestion,
            selectedOption: selectedOption,
            isCorrect: isCorrect
        ))
        
        nextQuestion()
    }
    
    private func nextQuestion() {
        timerSubscription?.cancel()
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            startTimer()
        } else {
            isQuizFinished = true
            Task {
                await saveHighScore()
            }
        }
    }
    
    func cancelQuiz() {
        timerSubscription?.cancel()
        hasStarted = false
        isQuizFinished = false
        quizAnswers = []
        score = 0
        currentQuestionIndex = 0
    }
    
    private func saveHighScore() async {
        do {
            try await quizService.saveHighScore(newScore: self.score)
        } catch {
            print("Gagal menyimpan skor ke database: \(error.localizedDescription)")
        }
    }
    
    func restartQuiz() {
        self.score = 0
        self.currentQuestionIndex = 0
        self.isQuizFinished = false
        self.timeRemaining = 10
        self.quizAnswers = []
        self.questions = self.questions.shuffled()
        startTimer()
    }
}

