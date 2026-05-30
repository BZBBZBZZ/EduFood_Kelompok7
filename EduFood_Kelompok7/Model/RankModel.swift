//
//  RankModel.swift
//  EduFood
//
//  Created by Hendrawan Saputro on 12/05/26.
//

import Foundation

struct RankModel: Identifiable, Codable {
    var id: UUID
    var nama: String
    var score: Int
}
