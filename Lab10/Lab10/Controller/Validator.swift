//
//  Validator.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 28.05.24.
//

import Foundation

class Validator {
    static func isEmpty(_ text: String) -> Bool {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    
    static func isStrongPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    static func passwordsMatch(_ password: String, _ confirmPassword: String) -> Bool {
        return password == confirmPassword
    }
    
    static func containsOnlyLetters(_ text: String) -> Bool {
        let letterCharacterSet = CharacterSet.letters
        return text.rangeOfCharacter(from: letterCharacterSet.inverted) == nil
    }
    
    static func containsOnlyNumbers(_ text: String) -> Bool {
        let numericCharacterSet = CharacterSet.decimalDigits
        return text.rangeOfCharacter(from: numericCharacterSet.inverted) == nil
    }
}

