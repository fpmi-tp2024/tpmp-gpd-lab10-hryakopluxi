//
//  LoginViewController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation
import UIKit

class LoginRegisterViewController: UIViewController {
    
    var isAgreed = false
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    // Login Form Outlets
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    // Registration Form Outlets
    @IBOutlet weak var agreementSwitch: UISwitch!
    @IBAction func agreementChecked(_ sender: Any) {
        if(agreementSwitch.isOn) {
            isAgreed = true
            registerButton.isEnabled = true
        }
        else {
            isAgreed = false
            registerButton.isEnabled = false
        }
    }
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var registerLoginTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var registerConfirmPasswordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var houseNumberTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    var clinics: [Clinic] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.isEnabled = false
        agreementSwitch.isOn = false
        clinics = ClinicController.shared.getAllClinics()
        //cityPickerMenu.delegate = self
        //cityPickerMenu.dataSource = self

        // Initially show login form and hide registration form
        updateView()
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        updateView()
    }

    func updateView() {
        let showRegister = segmentedControl.selectedSegmentIndex == 1

        registerView.isHidden = !showRegister
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let login = loginTextField.text, let password = passwordTextField.text else {
                showError("Please fill in all the fields.")
                return
            }

            // Validate fields
            if Validator.isEmpty(login) || Validator.isEmpty(password) {
                showError("Login and password are required.")
                return
            }

            // Hash the password
            let passHash = hashPassword(password)

        /*// Attempt to fetch user
        if let user = ClientController.shared.getUserByLogin(login: login), user.passHash == passHash {
            // Perform segue to ClinicsViewController
            performSegue(withIdentifier: "showClinics", sender: user)
        } else {
            // Show error message
            showError("Invalid login or password")
        }*/
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let login = registerLoginTextField.text,
                  let password = registerPasswordTextField.text,
                  let name = nameTextField.text,
                  let street = streetTextField.text,
                  let houseNumber = houseNumberTextField.text
            else {
                showError("Please fill in all the fields.")
                return
            }

            // Validate fields
            if Validator.isEmpty(login) || Validator.isEmpty(password) || Validator.isEmpty(name) || Validator.isEmpty(street) || Validator.isEmpty(houseNumber) {
                showError("All fields are required.")
                return
            }

            if !Validator.isStrongPassword(password) {
                showError("Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.")
                return
            }

            if !Validator.containsOnlyLetters(street) {
                showError("Street name should contain only letters.")
                return
            }

            if !Validator.containsOnlyNumbers(houseNumber) {
                showError("House number should contain only numbers.")
                return
            }

        if(!isAgreed) {
            showError("Firstly agree to terms.")
            return
        }

                // Find the clinic ID for the selected city
                

                

            let passHash = hashPassword(password)
        /*if let user = ClientController.shared.registerUser(
            login: login,
            passHash: passHash,
            clinicId: selectedClinicId,
            name: name,
            address: "\(street), \(houseNumber)",
            addressCoords: addressCoords) {
            // Perform segue to ClinicsViewController
            performSegue(withIdentifier: "showClinics", sender: user)
        } else {
            showError("Registration failed")
        }*/
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

/*extension LoginRegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return clinics.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return clinics[row].name
    }
}*/
