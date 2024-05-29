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
