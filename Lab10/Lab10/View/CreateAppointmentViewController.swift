//
//  CreateAppointmentViewController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 28.05.24.
//

import UIKit

class CreateAppointmentViewController: UIViewController {
    
    var appointment: Appointment = Appointment(id: -1, clientId: -1, clinicId: -1, departmentId: -1, doctorName: "", date: "")
    
    var departments = DepartmentController.shared.getDepartmentsByClinicId(clinicId: ClientSession.shared.currentUser.clinicId)
    
    @IBOutlet weak var chooseDepartmentButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.isHidden = true
        
        let today = Date()
        datePicker.minimumDate = Calendar.current.startOfDay(for: today)
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "departmentCell")
    }
    
    @IBAction func chooseDepartment(_ sender: Any) {
        tableView.isHidden = false
    }
    

    @IBAction func newAppointment(_ sender: Any) {
        appointment.clientId = ClientSession.shared.currentUser.id
        appointment.date = datePicker.date.toDateTimeString()
        print(appointment.date)
        appointment.clinicId = ClientSession.shared.currentUser.clinicId
        appointment.doctorName = "Dr. Khodin"
        AppointmentController.shared.addAppointment(appointment: appointment)

        let clientInfoVC = self.storyboard!.instantiateViewController(withIdentifier: "showInfo") as! ClientInfoViewController
        
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if let clientInfoVC = viewController as? ClientInfoViewController {
                    self.navigationController?.popToViewController(clientInfoVC, animated: true)
                    break
                }
            }
        }
        
    }
    
    @objc func datePickerChanged(_ picker: UIDatePicker) {
            let calendar = Calendar.current
            let selectedDate = picker.date
            let currentDate = Date()
            
            if calendar.isDate(selectedDate, inSameDayAs: currentDate) {
                var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
                let hour = components.hour ?? 0
                
                if hour < 7 {
                    components.hour = 7
                    components.minute = 0
                    if let newDate = calendar.date(from: components) {
                        picker.date = newDate
                    }
                } else if hour >= 20 {
                    components.hour = 20
                    components.minute = 0
                    if let newDate = calendar.date(from: components) {
                        picker.date = newDate
                    }
                } else if selectedDate < currentDate {
                    picker.date = currentDate
                }
            } else {
                var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
                let hour = components.hour ?? 0
                
                if hour < 7 {
                    components.hour = 7
                    components.minute = 0
                } else if hour >= 20 {
                    components.hour = 20
                    components.minute = 0
                }
                
                if let newDate = calendar.date(from: components) {
                    picker.date = newDate
                }
            }
        }

}

extension CreateAppointmentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "departmentCell", for: indexPath)
        cell.textLabel?.text = departments[indexPath.row].specialization
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDepartment = departments[indexPath.row]
        chooseDepartmentButton.setTitle(selectedDepartment.specialization, for: .normal)
        appointment.departmentId = selectedDepartment.id
        tableView.isHidden = true
    }
}
