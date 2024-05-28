//
//  Appointment.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation

struct Appointment: Codable {
    let id: Int
    let clientId: Int
    let clinicId: Int
    let departmentId: Int
    let doctorName: String
    var date: String
}
