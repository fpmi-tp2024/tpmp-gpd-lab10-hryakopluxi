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
    
    func createAppointment(clientId: Int, clinicId: Int, departmentId: Int, doctorName: String, date: Date, address: String) -> Int {
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
        return database.rescheduleAppointment(appointmentId: appointmentId, newDateString: newDateString)
    }
    
    func getAppointmentById(appointmentId: Int) -> Appointment? {
        return database.getAppointmentById(appointmentId)
    }
    
    func addAppointment(appointment: Appointment) {
        let id = database.addAppointment(appointment)
        var newApp = appointment
        newApp.id = id
        appointments.append(newApp)
        print(newApp)
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
