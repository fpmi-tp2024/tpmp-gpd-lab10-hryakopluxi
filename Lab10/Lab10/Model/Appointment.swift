//
//  Appointment.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation

struct Appointment: Codable {
    var id: Int
    var userId: Int
    var clinicId: Int
    var departmentId: Int
    var doctorName: String
    var date: Date
}
