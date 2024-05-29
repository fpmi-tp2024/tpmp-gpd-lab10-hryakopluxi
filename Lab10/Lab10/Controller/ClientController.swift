//
//  UserController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import Foundation

class ClientController {
    
    // MARK: - Properties
    static let shared = ClientController()
    private let database = DatabaseManager.shared
    
    // MARK: - Public Methods
    
    func registerUser(login: String, passHash: String, clinicId: Int, name: String, address: String, addressCoords: String) -> Client? {
        let userId = UUID().hashValue
        var user = Client(id: userId, login: login, passHash: passHash, clinicId: clinicId, name: name, address: address)
        var id = database.addUser(user)
        user.id = id
        return user
    }
    
    func getUserById(userId: Int) -> Client? {
        return database.getUserById(userId)
    }
    
    func getUserByLogin(login: String) -> Client? {
        return database.getUserByLogin(login)
    }
}

