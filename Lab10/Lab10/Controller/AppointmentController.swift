//
//  ApplicationController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation

class AppointmentController {
    
    // MARK: - Properties
    static let shared = AppointmentController()
    private let database = DatabaseManager.shared
    
    // MARK: - Public Methods
    
    func createAppointment(userId: Int, clinicId: Int, departmentId: Int, doctorName: String, date: Date) -> Bool {
        let appointmentId = UUID().hashValue
        let appointment = Appointment(id: appointmentId, userId: userId, clinicId: clinicId, departmentId: departmentId, doctorName: doctorName, date: date)
        return database.addAppointment(appointment)
    }
    
    func cancelAppointment(appointmentId: Int) -> Bool {
        return database.deleteAppointment(appointmentId)
    }
    
    func rescheduleAppointment(appointmentId: Int, newDate: Date) -> Bool {
        return database.updateAppointmentDate(appointmentId, newDate: newDate)
    }
    
    func getAppointmentsForUser(userId: Int) -> [Appointment] {
        return database.getAppointmentsByUserId(userId)
    }
    
    func getAppointmentById(appointmentId: Int) -> Appointment? {
        return database.getAppointmentById(appointmentId)
    }
}
