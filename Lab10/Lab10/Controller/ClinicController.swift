//
//  ClinicController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation

class ClinicController {
    
    // MARK: - Properties
    static let shared = ClinicController()
    private let database = DatabaseManager.shared
    
    // MARK: - Public Methods
    
    func addClinic(name: String, address: String, description: String,addressCoords: String, isPediatric: Bool, isHospital: Bool) -> Clinic? {
        let clinicId = UUID().hashValue
        let clinic = Clinic(id: clinicId, name: name, address: address, description: description,addressCoords: addressCoords, isPediatric: isPediatric, isHospital: isHospital)
        database.addClinic(clinic)
        return clinic
    }
    
    func getAllClinics() -> [Clinic] {
        return database.getAllClinics()
    }
    
    func getClinicById(clinicId: Int) -> Clinic? {
        return database.getClinicById(clinicId)
    }
}

