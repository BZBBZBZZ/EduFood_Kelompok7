//
//  UserModel.swift
//  EduFood
//
//  Created by Hendrawan Saputro on 11/05/26.
//

import Foundation

struct UserModel: Codable {
    var id: UUID
    var nama: String
    var email: String
    var score: Int
    var role: String
}
