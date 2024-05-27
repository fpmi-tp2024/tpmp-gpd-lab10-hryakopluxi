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
    
    private func createTables() {
        let createUsersTableQuery = """
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            login TEXT UNIQUE NOT NULL,
            pass_hash TEXT NOT NULL,
            clinic_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            birthdate TEXT NOT NULL,
            address TEXT NOT NULL,
            address_cords TEXT NOT NULL
        );
        """
        
        let createClinicsTableQuery = """
        CREATE TABLE IF NOT EXISTS clinics (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE NOT NULL,
            address TEXT NOT NULL,
            address_cords TEXT NOT NULL,
            is_pediatric INTEGER NOT NULL,
            is_hospital INTEGER NOT NULL
        );
        """
        
        let createDepartmentsTableQuery = """
        CREATE TABLE IF NOT EXISTS departments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            clinic_id INTEGER NOT NULL,
            specialization TEXT NOT NULL
        );
        """
        
        let createAppointmentsTableQuery = """
        CREATE TABLE IF NOT EXISTS appointments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            clinic_id INTEGER NOT NULL,
            department_id INTEGER NOT NULL,
            doctor_name TEXT NOT NULL,
            date TEXT NOT NULL
        );
        """
        
        executeQuery(createUsersTableQuery)
        executeQuery(createClinicsTableQuery)
        executeQuery(createDepartmentsTableQuery)
        executeQuery(createAppointmentsTableQuery)
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
        let insertQuery = "INSERT INTO users (login, pass_hash, clinic_id, name, birthdate, address, address_cords) VALUES (?, ?, ?, ?, ?, ?, ?);"
        
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, (user.login as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (user.passHash as NSString).utf8String, -1, nil)
            sqlite3_bind_int(stmt, 3, Int32(user.clinicId))
            sqlite3_bind_text(stmt, 4, (user.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 5, (user.birthdate.description as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 6, (user.address as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 7, (user.addressCoords as NSString).utf8String, -1, nil)
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                print("Insert failed: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Error preparing insert: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(stmt)
    }
    
    func getUserById(_ id: Int) -> Client? {
        let query = "SELECT * FROM users WHERE id = ?;"
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
                    birthdate: Date(), // Convert from string if needed
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
    
    // Other CRUD operations for users, clinics, departments, and appo
}
