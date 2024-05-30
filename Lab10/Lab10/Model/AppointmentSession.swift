//
//  AppointmentSession.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 29.05.24.
//

import Foundation

class AppointmentSession {
    static let shared = AppointmentSession()
    
    var editedAppointmentId : Int
    
    private init() {
        editedAppointmentId = -1
    }

    
}
