//  ClientInfoViewController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation
import UIKit

class ClientInfoViewController: UIViewController {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var clinicLabel: UILabel!
    @IBOutlet weak var changeClinicButton: UIButton!
    @IBOutlet weak var clientIcon: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clinicTitleLabel: UILabel!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var addressInfoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var user: Client!
    var clinic: Clinic!
    var departments: [Department] = []
    var appointments: [Appointment] = [] // New array to store appointments
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the custom table view cell
        tableView.register(AppointmentTableViewCell.self, forCellReuseIdentifier: "appointmentCell")
        
        appointments = AppointmentController.shared.getAppointmentsByClientId(clientId: ClientSession.shared.currentUser.id)
        
        fullNameLabel.text = ClientSession.shared.currentUser.name
        addressLabel.text = ClientSession.shared.currentUser.address
        
        clinicLabel.text = ClinicController.shared.getClinicById(clinicId: ClientSession.shared.currentUser.clinicId)?.name
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        infoView.isHidden = true // Hide infoView initially
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAppointments", let appointmentsVC = segue.destination as? CreateAppointmentViewController, let department = sender as? Department {
            
        } else if segue.identifier == "changeClinic", let clinicsVC = segue.destination as? ClinicsViewController {
            clinicsVC.delegate = self
        }
    }
    
    @IBAction func changeClinic(_ sender: Any) {
        performSegue(withIdentifier: "changeClinic", sender: nil)
    }
    
    @IBAction func getNewAppointment(_ sender: Any) {
        // Add your action code here
    }
    
    func displayAppointmentDetails(_ appointment: Appointment) {
        let clinic = ClinicController.shared.getClinicById(clinicId: ClientSession.shared.currentUser.clinicId)
        clinicTitleLabel.text = clinic?.name
        
        let department = DepartmentController.shared.getDepartmentById(id: appointment.departmentId)
        
        departmentLabel.text = department?.specialization
        doctorNameLabel.text = appointment.doctorName
        
        let dateTimeComponents = appointment.date.components(separatedBy: " ")
        if dateTimeComponents.count == 2 {
            dateLabel.text = dateTimeComponents[0]
            timeLabel.text = dateTimeComponents[1]
        } else {
            dateLabel.text = "Invalid date format"
            timeLabel.text = "Invalid time format"
        }
        infoView.isHidden = false
    }
}

extension ClientInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath) as! AppointmentTableViewCell
        let appointment = appointments[indexPath.row]
        let department = DepartmentController.shared.getDepartmentById(id: appointment.departmentId)
        cell.textLabel?.text = department?.specialization
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAppointment = appointments[indexPath.row]
        displayAppointmentDetails(selectedAppointment)
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        let appointment = appointments[sender.tag]
        performSegue(withIdentifier: "editAppointment", sender: appointment)
    }
}

extension ClientInfoViewController: ClinicSelectionDelegate {
    func clinicSelected(_ clinic: Clinic) {
        didSelectClinic(clinic)
    }
    
    func didSelectClinic(_ clinic: Clinic) {
        self.clinic = clinic
        self.clinicLabel.text = clinic.name
        departments = DepartmentController.shared.getDepartmentsByClinicId(clinicId: clinic.id)
        appointments = AppointmentController.shared.getAppointmentsByClientId(clientId: user.id)
        tableView.reloadData()
        infoView.isHidden = true
    }
}

class AppointmentTableViewCell: UITableViewCell {
    @IBOutlet weak var appointmentLabel: UILabel!
    
    @IBAction func editAppointment(_ sender: Any) {
        
    }
    
    
}
