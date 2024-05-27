//
//  DepartmanetsViewController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation
import UIKit

class DepartmentsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var user: Client!
    var clinic: Clinic!
    var departments: [Department] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        departments = DepartmentController.shared.getDepartmentsByClinicId(clinicId: clinic.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAppointments", let appointmentsVC = segue.destination as? AppointmentsViewController, let department = sender as? Department {
            appointmentsVC.user = user
            appointmentsVC.clinic = clinic
            appointmentsVC.department = department
        }
    }
}

extension DepartmentsViewController: UITableViewDelegate, UITableViewDataSource {
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
        performSegue(withIdentifier: "showAppointments", sender: selectedDepartment)
    }
}
