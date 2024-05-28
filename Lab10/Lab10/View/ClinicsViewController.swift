//
//  ClinicsViewController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import UIKit

protocol ClinicSelectionDelegate: AnyObject {
    func clinicSelected(_ clinic: Clinic)
}

class ClinicsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clinicNameLabel: UILabel!
    @IBOutlet weak var clinicAddressLabel: UILabel!
    @IBOutlet weak var clinicDescriptionTextView: UITextView!
    @IBOutlet weak var chooseButton: UIButton!
    
    var clinics: [Clinic] = []
    weak var delegate: ClinicSelectionDelegate?
    var selectedClinic: Clinic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clinics = ClinicController.shared.getAllClinics()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "clinicCell")
        
        // Hide clinic details initially
        updateClinicDetails(with: nil)
        chooseButton.isHidden = true
    }
    
    func updateClinicDetails(with clinic: Clinic?) {
        if let clinic = clinic {
            clinicNameLabel.text = clinic.name
            clinicAddressLabel.text = clinic.address
            clinicDescriptionTextView.text = clinic.description
            clinicNameLabel.isHidden = false
            clinicAddressLabel.isHidden = false
            clinicDescriptionTextView.isHidden = false
            chooseButton.isHidden = false
            selectedClinic = clinic
        } else {
            clinicNameLabel.isHidden = true
            clinicAddressLabel.isHidden = true
            clinicDescriptionTextView.isHidden = true
            chooseButton.isHidden = true
            selectedClinic = nil
        }
    }
    
    @IBAction func chooseButtonTapped(_ sender: UIButton) {
        guard let clinic = selectedClinic else { return }
        delegate?.clinicSelected(clinic)
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
        updateClinicDetails(with: selectedClinic)
    }
}
