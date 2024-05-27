//
//  ClinicsViewController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation
import UIKit

class ClinicsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var user: Client!
    var clinics: [Clinic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clinics = ClinicController.shared.getAllClinics()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "clinicCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDepartments", let departmentsVC = segue.destination as? DepartmentsViewController, let clinic = sender as? Clinic {
            departmentsVC.user = user
            departmentsVC.clinic = clinic
        }
    }
}

extension ClinicsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clinics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clinicCell", for: indexPath)
        cell.textLabel?.text = clinics[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedClinic = clinics[indexPath.row]
        performSegue(withIdentifier: "showDepartments", sender: selectedClinic)
    }
}
