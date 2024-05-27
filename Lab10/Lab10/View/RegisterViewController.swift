//
//  RegisterViewController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdatePicker: UIDatePicker!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressCoordsTextField: UITextField!
    @IBOutlet weak var clinicPicker: UIPickerView!
    
    var clinics: [Clinic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clinics = ClinicController.shared.getAllClinics()
        clinicPicker.delegate = self
        clinicPicker.dataSource = self
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text,
              let name = nameTextField.text,
              let address = addressTextField.text,
              let addressCoords = addressCoordsTextField.text else { return }
        
        let passHash = hashPassword(password)
        let birthdate = birthdatePicker.date
        let selectedClinicId = clinics[clinicPicker.selectedRow(inComponent: 0)].id
        
        if let user = ClientController.shared.registerUser(login: login, passHash: passHash, clinicId: selectedClinicId, name: name, birthdate: birthdate, address: address, addressCoords: addressCoords) {
            // Perform segue to ClinicsViewController
            performSegue(withIdentifier: "showClinics", sender: user)
        } else {
            showError("Registration failed")
        }
    }
    
    func hashPassword(_ password: String) -> String {
        // Implement password hashing
        return password // Placeholder
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showClinics", let clinicsVC = segue.destination as? ClinicsViewController, let user = sender as? Client {
            clinicsVC.user = user
        }
    }
}

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return clinics.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return clinics[row].name
    }
}
