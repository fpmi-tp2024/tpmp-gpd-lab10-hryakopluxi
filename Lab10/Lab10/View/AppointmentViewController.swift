// AppointmentViewController.swift
// Lab10
//
// Created by Yulia Raitsyna on 27.05.24.

import Foundation
import UIKit

class AppointmentViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var departmentMenuButton: UIButton!
    
    var user: Client!
    var clinic: Clinic!
    var departments: [Department] = []
    var selectedDepartment: Department?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        departments = DepartmentController.shared.getDepartmentsByClinicId(clinicId: clinic.id)
        setupDepartmentMenu()
    }
    
    func setupDepartmentMenu() {
        let menuItems = departments.map { department in
            UIAction(title: department.specialization, handler: { _ in
                self.selectedDepartment = department
                self.departmentMenuButton.setTitle(department.specialization, for: .normal)
            })
        }
        let menu = UIMenu(title: "Choose Department", children: menuItems)
        departmentMenuButton.menu = menu
        departmentMenuButton.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func getNewAppointment(_ sender: Any) {
        guard let selectedDepartment = selectedDepartment else {
            showAlert(message: "Please select a department.")
            return
        }
        
        let selectedDate = datePicker.date
        let dateString = dateToString(selectedDate)
        
        // Create the new appointment
        let appointment = Appointment(
            id: UUID().hashValue, // Generating a unique ID for the appointment
            clientId: user.id,
            clinicId: clinic.id,
            departmentId: selectedDepartment.id,
            doctorName: "Doctor Name", // Replace with actual doctor name if available
            date: dateString
        )
        
        AppointmentController.shared.addAppointment(appointment)
        
        showAlert(message: "Appointment successfully created!")
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}
