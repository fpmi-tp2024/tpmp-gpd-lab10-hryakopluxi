//
//
//  EditAppointmentViewController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 28.05.24.
//

import Foundation
import UIKit

class EditAppointmentViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appointment =  AppointmentController.shared.getAppointmentById(appointmentId: AppointmentSession.shared.editedAppointmentId)
        print(appointment)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if let date = dateFormatter.date(from: appointment!.date) {
            datePicker.date = date
        } else {
            print("Date can't be set")
        }
        
        let today = Date()
        datePicker.minimumDate = Calendar.current.startOfDay(for: today)
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
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
    
    @IBAction func editAppointment(_ sender: Any) {
        _ = AppointmentController.shared.rescheduleAppointment(appointmentId: AppointmentSession.shared.editedAppointmentId, newDateString: datePicker.date.toDateTimeString())
        
        print(AppointmentSession.shared.editedAppointmentId)
        
        print(AppointmentController.shared.getAppointmentById(appointmentId: AppointmentSession.shared.editedAppointmentId))
        
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if let clientInfoVC = viewController as? ClientInfoViewController {
                    self.navigationController?.popToViewController(clientInfoVC, animated: true)
                    break
                }
            }
        }
    }
}
