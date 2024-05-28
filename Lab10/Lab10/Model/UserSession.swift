//
//  UserSession.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 28.05.24.
//

import Foundation

class ClientSession {
    static let shared = ClientSession()
    
    var currentUser: Client
    
    private init() {
        currentUser = Client(id: -1, login: "", passHash: "", clinicId: -1, name: "", address: "", addressCoords: "")
    }
}

