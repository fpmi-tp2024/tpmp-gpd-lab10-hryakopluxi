import Foundation
import UIKit
import CoreLocation

class LoginRegisterViewController: UIViewController, ClinicSelectionDelegate {
    
    var isAgreed = false
    var isSuccessful = true
    var selectedClinic: Clinic?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
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
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var selectClinicButton: UIButton!
    
    var clinics: [Clinic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.isEnabled = false
        agreementSwitch.isOn = false
        clinics = ClinicController.shared.getAllClinics()
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
        
        if Validator.isEmpty(login) || Validator.isEmpty(password) {
            showError("Login and password are required.")
            return
        }
        
        let passHash = hashPassword(password)
        
        if let user = ClientController.shared.getUserByLogin(login: login), user.passHash == passHash {
            ClientSession.shared.currentUser = user
            performSegue(withIdentifier: "showInfo", sender: user)
        } else {
            showError("Invalid login or password")
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let login = registerLoginTextField.text,
              let password = registerPasswordTextField.text,
              let name = nameTextField.text,
              let street = streetTextField.text,
              let city = cityTextField.text,
              let houseNumber = houseNumberTextField.text else {
            showError("Please fill in all the fields.")
            isSuccessful = false
            return
        }
        
        if Validator.isEmpty(login) || Validator.isEmpty(password) || Validator.isEmpty(name) || Validator.isEmpty(street) || Validator.isEmpty(houseNumber) || Validator.isEmpty(city) {
            showError("All fields are required.")
            isSuccessful = false
            return
        }
        
        if !Validator.isStrongPassword(password) {
            showError("Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.")
            isSuccessful = false
            return
        }
        
        if !Validator.containsOnlyLetters(street) || !Validator.containsOnlyLetters(city) {
            showError("Street name and city should contain only letters.")
            isSuccessful = false
            return
        }
        
        if !Validator.containsOnlyNumbers(houseNumber) {
            showError("House number should contain only numbers.")
            isSuccessful = false
            return
        }
        
        if !isAgreed {
            showError("Firstly agree to terms.")
            isSuccessful = false
            return
        }
        
        if ClientSession.shared.currentUser.clinicId == -1 {
            showError("Please choose a clinic")
            isSuccessful = false
            return
        }
        
        let passHash = hashPassword(password)
        let address = "\(street) \(houseNumber), \(city)"
        
        if let user = ClientController.shared.registerUser(
            login: login,
            passHash: passHash,
            clinicId: ClientSession.shared.currentUser.clinicId,
            name: name,
            address: address,
            addressCoords: address) {
            // Perform segue to ClientInfoViewController
            ClientSession.shared.currentUser = user
            print(ClientSession.shared.currentUser)
        } else {
            self.showError("Registration failed")
            isSuccessful = false
        }
        
        if isSuccessful {
            self.performSegue(withIdentifier: "showInfo", sender: ClientSession.shared.currentUser)
        }
    }
    
    func hashPassword(_ password: String) -> String {
        // Implement password hashing
        return password // Placeholder
    }
    
    func addressToCoords(address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let placemarks = placemarks, let location = placemarks.first?.location {
                completion(location.coordinate, nil)
            } else {
                completion(nil, NSError(domain: "com.example.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "No location found"]))
            }
        }
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfo", let clientInfoVC = segue.destination as? ClientInfoViewController {
            clientInfoVC.user = sender as? Client
        } else if segue.identifier == "showClinics", let clinicsVC = segue.destination as? ClinicsViewController {
            clinicsVC.delegate = self
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showInfo" {
            // Return false to prevent the segue from being performed automatically
            return false
        }
        return true
    }

    
    @IBAction func selectClinicTapped(_ sender: UIButton) {
        if let clinicsVC = navigationController?.topViewController as? ClinicsViewController {
            clinicsVC.delegate = self
        } else {
            performSegue(withIdentifier: "showClinics", sender: nil)
        }
    }
    
    func clinicSelected(_ clinic: Clinic) {
        selectedClinic = clinic
        print("Selected clinic: \(clinic)") // Print clinic info in console
        
    }
}
