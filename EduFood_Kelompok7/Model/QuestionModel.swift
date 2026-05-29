//
//  QuestionModel.swift
//  EduFood_Kelompok7
//
//  Created by Dave on 29/05/26.
//

import Foundation

struct QuestionModel: Identifiable, Codable {
    var id: UUID
    var pertanyaan: String
    var opsiA: String
    var opsiB: String
    var opsiC: String
    var opsiD: String
    var kunciJawaban: String // Berisi "A", "B", "C", atau "D"
    var pembahasan: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case pertanyaan
        case opsiA = "opsi_a"
        case opsiB = "opsi_b"
        case opsiC = "opsi_c"
        case opsiD = "opsi_d"
        case kunciJawaban = "kunci_jawaban"
        case pembahasan
    }
}

