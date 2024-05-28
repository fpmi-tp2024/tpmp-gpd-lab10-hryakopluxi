//
//  DepartmentController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation

class DepartmentController {
    
    // MARK: - Properties
    static let shared = DepartmentController()
    private let database = DatabaseManager.shared
    
    // MARK: - Public Methods
    
    func addDepartment(clinicId: Int, specialization: String) -> Department? {
        let departmentId = UUID().hashValue
        let department = Department(id: departmentId, clinicId: clinicId, specialization: specialization)
        database.addDepartment(department)
        return department
    }
    
    func getDepartmentsByClinicId(clinicId: Int) -> [Department] {
        return database.getDepartmentsByClinicId(clinicId)
    }
    
    func getDepartmentById(id: Int) -> Department? {
        return database.getDepartmentById(id: id)
    }
}

