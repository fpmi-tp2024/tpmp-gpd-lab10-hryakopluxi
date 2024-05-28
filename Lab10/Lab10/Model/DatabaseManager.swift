import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var db: OpaquePointer?
    
    public func openDatabase(path: String) {
        if sqlite3_open(path, &db) != SQLITE_OK {
            print("Unable to open database.")
        }
    }
    
    private func executeQuery(_ query: String) {
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) != SQLITE_DONE {
                print("Error executing query: \(query)")
            }
        } else {
            print("Error preparing query: \(query)")
        }
        sqlite3_finalize(stmt)
    }
    
    // CRUD operations for users
    func addUser(_ user: Client) {
        let insertQuery = "INSERT INTO client (login, pass_hash, clinic_id, name, address, address_cords) VALUES (?, ?, ?, ?, ?, ?);"
        
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, (user.login as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (user.passHash as NSString).utf8String, -1, nil)
            sqlite3_bind_int(stmt, 3, Int32(user.clinicId))
            sqlite3_bind_text(stmt, 4, (user.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 5, (user.address as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 6, (user.addressCoords as NSString).utf8String, -1, nil)
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                print("Insert failed: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Error preparing insert: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(stmt)
    }
    
    func getUserById(_ id: Int) -> Client? {
        let query = "SELECT * FROM client WHERE id = ?;"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int(stmt, 1, Int32(id))
            
            if sqlite3_step(stmt) == SQLITE_ROW {
                let user = Client(
                    id: Int(sqlite3_column_int(stmt, 0)),
                    login: String(cString: sqlite3_column_text(stmt, 1)),
                    passHash: String(cString: sqlite3_column_text(stmt, 2)),
                    clinicId: Int(sqlite3_column_int(stmt, 3)),
                    name: String(cString: sqlite3_column_text(stmt, 4)),
                    address: String(cString: sqlite3_column_text(stmt, 6)),
                    addressCoords: String(cString: sqlite3_column_text(stmt, 7))
                )
                sqlite3_finalize(stmt)
                return user
            }
        } else {
            print("Error preparing select: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(stmt)
        return nil
    }
    
    func getUserByLogin(_ login: String) -> Client? {
        let query = "SELECT * FROM client WHERE login = ?;"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, (login as NSString).utf8String, -1, nil)
            
            if sqlite3_step(stmt) == SQLITE_ROW {
                let user = Client(
                    id: Int(sqlite3_column_int(stmt, 0)),
                    login: String(cString: sqlite3_column_text(stmt, 1)),
                    passHash: String(cString: sqlite3_column_text(stmt, 2)),
                    clinicId: Int(sqlite3_column_int(stmt, 3)),
                    name: String(cString: sqlite3_column_text(stmt, 4)),
                    address: String(cString: sqlite3_column_text(stmt, 5)),
                    addressCoords: String(cString: sqlite3_column_text(stmt, 6))
                )
                sqlite3_finalize(stmt)
                return user
            }
        } else {
            print("Error preparing select: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(stmt)
        return nil
    }
    // CRUD operations for clinics
    func addClinic(_ clinic: Clinic) {
        let insertQuery = "INSERT INTO clinic (name, address, address_cords, is_pediatric, is_hospital) VALUES (?, ?, ?, ?, ?);"
        
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, (clinic.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (clinic.address as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 3, (clinic.addressCoords as NSString).utf8String, -1, nil)
            sqlite3_bind_int(stmt, 4, clinic.isPediatric ? 1 : 0)
            sqlite3_bind_int(stmt, 5, clinic.isHospital ? 1 : 0)
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                print("Insert failed: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Error preparing insert: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(stmt)
    }
    
    func getAllClinics() -> [Clinic] {
        let query = "SELECT * FROM clinic;"
        var stmt: OpaquePointer?
        var result = [Clinic]()
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let clinic = Clinic(
                    id: Int(sqlite3_column_int(stmt, 0)),
                    name: String(cString: sqlite3_column_text(stmt, 1)),
                    address: String(cString: sqlite3_column_text(stmt, 2)),
                    description: String(cString: sqlite3_column_text(stmt, 3)),
                    addressCoords: String(cString: sqlite3_column_text(stmt, 4)),
                    isPediatric: sqlite3_column_int(stmt, 5) != 0,
                    isHospital: sqlite3_column_int(stmt, 6) != 0
                )
                result.append(clinic)
            }
        } else {
            print("Error preparing select: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(stmt)
        return result
    }
    
    func getClinicById(_ clinicId: Int) -> Clinic? {
        let query = "SELECT * FROM clinic WHERE id = ?;"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int(stmt, 1, Int32(clinicId))
            
            if sqlite3_step(stmt) == SQLITE_ROW {
                let clinic = Clinic(
                    id: Int(sqlite3_column_int(stmt, 0)),
                    name: String(cString: sqlite3_column_text(stmt, 1)),
                    address: String(cString: sqlite3_column_text(stmt, 2)),
                    description: String(cString: sqlite3_column_text(stmt, 3)),
                    addressCoords: String(cString: sqlite3_column_text(stmt, 4)),
                    isPediatric: sqlite3_column_int(stmt, 5) != 0,
                    isHospital: sqlite3_column_int(stmt, 6) != 0
                )
                sqlite3_finalize(stmt)
                return clinic
            }
        } else {
            print("Error preparing select: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(stmt)
        return nil
    }
    
    // CRUD operations for departments
    func addDepartment(_ department: Department) {
        let insertQuery = "INSERT INTO department (clinic_id, specialization) VALUES (?, ?);"
        
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int(stmt, 1, Int32(department.clinicId))
            sqlite3_bind_text(stmt, 2, (department.specialization as NSString).utf8String, -1, nil)
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                print("Insert failed: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Error preparing insert: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(stmt)
    }
    
    func getDepartmentsByClinicId(_ clinicId: Int) -> [Department] {
        let query = "SELECT * FROM department WHERE clinic_id = ?;"
        var stmt: OpaquePointer?
        var result = [Department]()
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int(stmt, 1, Int32(clinicId))
            
            while sqlite3_step(stmt) == SQLITE_ROW {
                let department = Department(
                    id: Int(sqlite3_column_int(stmt, 0)),
                    clinicId: Int(sqlite3_column_int(stmt, 1)),
                    specialization: String(cString: sqlite3_column_text(stmt, 2))
                )
                result.append(department)
            }
        } else {
            print("Error preparing select: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(stmt)
        return result
    }
    
    // CRUD operations for appointments
    func addAppointment(_ appointment: Appointment) -> Bool {
        let insertQuery = "INSERT INTO appointment (client_id, clinic_id, department_id, doctor_name, date) VALUES (?, ?, ?, ?, ?);"
        
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int(stmt, 1, Int32(appointment.clientId))
            sqlite3_bind_int(stmt, 2, Int32(appointment.clinicId))
            sqlite3_bind_int(stmt, 3, Int32(appointment.departmentId))
            sqlite3_bind_text(stmt, 4, (appointment.doctorName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 5, (appointment.date.description as NSString).utf8String, -1, nil)
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                print("Insert failed: \(String(cString: sqlite3_errmsg(db)))")
                return false
            }
            return true
        }
        
        print("Error preparing insert: \(String(cString: sqlite3_errmsg(db)))")
        sqlite3_finalize(stmt)
        return false
    }
    
    func deleteAppointment(_ appointmentId: Int) -> Bool {
        let deleteQuery = "DELETE FROM appointment WHERE id = ?;"
        
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int(stmt, 1, Int32(appointmentId))
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                print("Delete failed: \(String(cString: sqlite3_errmsg(db)))")
                return false
            }
            return true
        }
        
        print("Error preparing delete: \(String(cString: sqlite3_errmsg(db)))")
        sqlite3_finalize(stmt)
        return false
        
    }
    
    func updateAppointmentDate(_ appointmentId: Int, newDate: Date) -> Bool {
        let updateQuery = "UPDATE appointment SET date = ? WHERE id = ?;"
        
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, (newDate.description as NSString).utf8String, -1, nil)
            sqlite3_bind_int(stmt, 2, Int32(appointmentId))
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                print("Update failed: \(String(cString: sqlite3_errmsg(db)))")
                return false
            }
            return true
        } else {
            print("Error preparing update: \(String(cString: sqlite3_errmsg(db)))")
            return false
        }
        
        sqlite3_finalize(stmt)
    }
    
    func getAppointmentsByUserId(_ userId: Int) -> [Appointment] {
        let query = "SELECT * FROM appointment WHERE client_id = ?;"
        var stmt: OpaquePointer?
        var result = [Appointment]()
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int(stmt, 1, Int32(userId))
            
            while sqlite3_step(stmt) == SQLITE_ROW {
                let appointment = Appointment(
                    id: Int(sqlite3_column_int(stmt, 0)),
                    clientId: Int(sqlite3_column_int(stmt, 1)),
                    clinicId: Int(sqlite3_column_int(stmt, 2)),
                    departmentId: Int(sqlite3_column_int(stmt, 3)),
                    doctorName: String(cString: sqlite3_column_text(stmt, 4)),
                    date: String(cString: sqlite3_column_text(stmt, 5))
                )
                result.append(appointment)
            }
        } else {
            print("Error preparing select: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(stmt)
        return result
    }
    
    func getAppointmentById(_ appointmentId: Int) -> Appointment? {
        let query = "SELECT * FROM appointment WHERE id = ?;"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int(stmt, 1, Int32(appointmentId))
            
            if sqlite3_step(stmt) == SQLITE_ROW {
                let appointment = Appointment(
                    id: Int(sqlite3_column_int(stmt, 0)),
                    clientId: Int(sqlite3_column_int(stmt, 1)),
                    clinicId: Int(sqlite3_column_int(stmt, 2)),
                    departmentId: Int(sqlite3_column_int(stmt, 3)),
                    doctorName: String(cString: sqlite3_column_text(stmt, 4)),
                    date: String(cString: sqlite3_column_text(stmt, 5))
                )
                sqlite3_finalize(stmt)
                return appointment
            }
        } else {
            print("Error preparing select: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(stmt)
        return nil
    }
    
    func rescheduleAppointment(appointmentId: Int, newDateString: String) -> Bool {
        var updateStatement: OpaquePointer?
        let updateStatementString = "UPDATE appointment SET date = ? WHERE id = ?;"

            // Prepare the update statement
            if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                // Bind the new date and appointment ID to the statement
                sqlite3_bind_text(updateStatement, 1, (newDateString as NSString).utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 2, Int32(appointmentId))
                
                // Execute the statement
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("Successfully updated appointment date.")
                    sqlite3_finalize(updateStatement)
                    return true
                } else {
                    print("Could not update appointment date.")
                    sqlite3_finalize(updateStatement)
                    return false
                }
            } else {
                print("Update statement could not be prepared.")
            }
        
        return false
    }
    
    func getDepartmentById(id: Int) -> Department? {
        let query = "SELECT * FROM department WHERE id = ?;"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int(stmt, 1, Int32(id))
            
            if sqlite3_step(stmt) == SQLITE_ROW {
                let department = Department(
                    id: Int(sqlite3_column_int(stmt, 0)),
                    clinicId: Int(sqlite3_column_int(stmt, 1)),
                    specialization: String(cString: sqlite3_column_text(stmt, 2))
                )
                sqlite3_finalize(stmt)
                print(department)
                return department
            }
        }
        print("Error preparing select: \(String(cString: sqlite3_errmsg(db)))")
        sqlite3_finalize(stmt)
    
        return nil
    }
}
