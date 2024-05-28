// AppointmentController.swift
// Lab10
//
// Created by Yulia Raitsyna on 27.05.24.

import Foundation

class AppointmentController {
    
    // MARK: - Properties
    static let shared = AppointmentController()
    private let database = DatabaseManager.shared
    private var appointments: [Appointment] = []
    
    // MARK: - Public Methods
    
    func createAppointment(clientId: Int, clinicId: Int, departmentId: Int, doctorName: String, date: Date, address: String) -> Bool {
        let appointmentId = UUID().hashValue
        let dateString = date.toDateTimeString()
        let appointment = Appointment(id: appointmentId, clientId: clientId, clinicId: clinicId, departmentId: departmentId, doctorName: doctorName, date: dateString)
        appointments.append(appointment)
        return database.addAppointment(appointment)
    }
    
    func cancelAppointment(appointmentId: Int) -> Bool {
        if let index = appointments.firstIndex(where: { $0.id == appointmentId }) {
            appointments.remove(at: index)
            return database.deleteAppointment(appointmentId)
        }
        return false
    }
    
    func rescheduleAppointment(appointmentId: Int, newDateString: String) -> Bool {
        
        let index = appointments.firstIndex(where: { $0.id == appointmentId })
        
        if index != nil && database.rescheduleAppointment(appointmentId: appointmentId, newDateString: newDateString){
            appointments[index!].date = newDateString
            return true
        }
        
        print("Invalid appointment")
        return false
    }
    
    func getAppointmentById(appointmentId: Int) -> Appointment? {
        return database.getAppointmentById(appointmentId)
    }
    
    func addAppointment(_ appointment: Appointment) -> Bool {
        appointments.append(appointment)
        return database.addAppointment(appointment)
    }
    
    func getAppointmentsByClientId(clientId: Int) -> [Appointment] {
        return database.getAppointmentsByUserId(clientId)
    }
}

extension Date {
    func toDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: self)
    }
}
