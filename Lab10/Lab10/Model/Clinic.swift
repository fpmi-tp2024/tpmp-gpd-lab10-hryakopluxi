//
//  Clinic.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation

struct Clinic: Codable {
    var id: Int
    var name: String
    var address: String
    var addressCoords: String
    var isPediatric: Bool
    var isHospital: Bool
}
