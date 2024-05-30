//  ClientInfoViewController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation
import UIKit


class ClientInfoViewController: UIViewController {
    
    @IBOutlet weak var pediatricIcon: UIImageView!
    @IBOutlet weak var hospitalIcon: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var clinicLabel: UILabel!

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
    var appointments: [Appointment] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.register(AppointmentTableViewCell.self, forCellReuseIdentifier: "appointmentCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        infoView.isHidden = true
        
        clientIcon.image = UIImage(named: "ClientIcon")
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        infoView.isHidden = true
    }
    
    func loadData() {
        user = ClientSession.shared.currentUser
        appointments = AppointmentController.shared.getAppointmentsByClientId(clientId: user.id)
        
        fullNameLabel.text = user.name
        addressLabel.text = user.address
        
        clinic = ClinicController.shared.getClinicById(clinicId: user.clinicId)
        clinicLabel.text = clinic?.name
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAppointments", let appointmentsVC = segue.destination as? CreateAppointmentViewController, let department = sender as? Department {
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "newAppointment" || identifier == "editAppointment" {
            return false
        }
        return true
    }
    
    @IBAction func getNewAppointment(_ sender: Any) {
        performSegue(withIdentifier: "newAppointment", sender: nil)
    }
    
    @IBAction func editAppointment(_ sender: Any) {
        performSegue(withIdentifier: "editAppointment", sender: nil)
    }
    
    func displayAppointmentDetails(_ appointment: Appointment) {
        clinic = ClinicController.shared.getClinicById(clinicId: user.clinicId)
        clinicTitleLabel.text = clinic?.name
        
        if(clinic.isPediatric) {
            pediatricIcon.image = UIImage(named: "ChildrenIcon")
        }
        else {
            pediatricIcon.image = UIImage(named: "AdultIcon")
        }
        
        if(clinic.isHospital) {
            hospitalIcon.image = UIImage(named: "HospitalIcon")
        }
        
        let department = DepartmentController.shared.getDepartmentById(id: appointment.departmentId)
        
        departmentLabel.text = department?.specialization
        addressInfoLabel.text = ClinicController.shared.getClinicById(clinicId: ClientSession.shared.currentUser.clinicId)?.address
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
        
        AppointmentSession.shared.editedAppointmentId = selectedAppointment.id
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            _ = AppointmentController.shared.cancelAppointment(appointmentId: appointments[indexPath.row].id)
            
            //delete from db
            appointments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
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
}
