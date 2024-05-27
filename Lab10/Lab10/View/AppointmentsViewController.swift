//
//  AppointmentsViewController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation
import UIKit

class AppointmentsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var user: Client!
    var clinic: Clinic!
    var department: Department!
    var appointments: [Appointment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appointments = AppointmentController.shared.getAppointmentsForUser(userId: user.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func addAppointmentButtonTapped(_ sender: UIBarButtonItem) {
        // Implement logic to add appointment
    }
}

extension AppointmentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath)
        let appointment = appointments[indexPath.row]
        cell.textLabel?.text = "\(appointment.doctorName) - \(appointment.date)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAppointment = appointments[indexPath.row]
        // Implement logic for appointment details or edit
    }
}
