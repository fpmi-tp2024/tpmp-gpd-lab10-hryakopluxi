import Foundation
import UIKit

class LoginRegisterViewController: UIViewController, ClinicSelectionDelegate {
    
    var isAgreed = false
    var selectedCity: String?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    // Login Form Outlets
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    // Registration Form Outlets
    @IBOutlet weak var agreementSwitch: UISwitch!
    @IBAction func agreementChecked(_ sender: Any) {
        if agreementSwitch.isOn {
            isAgreed = true
            registerButton.isEnabled = true
        } else {
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
    @IBOutlet weak var cityPickerButton: UIButton!

    var clinics: [Clinic] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.isEnabled = false
        agreementSwitch.isOn = false
        selectedCity = ""
        clinics = ClinicController.shared.getAllClinics()
        
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

        // Attempt to fetch user
        /*if let user = ClientController.shared.getUserByLogin(login: login), user.passHash == passHash {
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

        if !isAgreed {
            showError("Firstly agree to terms.")
            return
        }
        
        guard let selectedCity = selectedCity else {
            showError("Please choose a city.")
            return
        }

        // Find the clinic ID for the selected city
        /*let selectedClinic = clinics.first(where: { $0.name == selectedCity })
        guard let selectedClinicId = selectedClinic?.id else {
            showError("Invalid selected city.")
            return
        }*/

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
        if segue.identifier == "showClinics", let clinicsVC = segue.destination as? ClinicsViewController {
            clinicsVC.user = sender as? Client
            clinicsVC.delegate = self
        }
    }

    // ClinicSelectionDelegate method
    func clinicSelected(_ clinic: Clinic) {
        selectedCity = clinic.name
        cityPickerButton.setTitle(clinic.name, for: .normal)
    }
}
