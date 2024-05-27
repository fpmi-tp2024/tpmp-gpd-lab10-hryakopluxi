//
//  LoginViewController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let login = loginTextField.text, let password = passwordTextField.text else { return }
        
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

