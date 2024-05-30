//
//  User.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation

struct Client: Codable {
    var id: Int
    var login: String
    var passHash: String
    var clinicId: Int
    var name: String
    var address: String
}
