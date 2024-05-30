import XCTest
@testable import Lab10

class DatabaseManagerTests: XCTestCase {
    
    var dbManager: DatabaseManager!
    
    func initializeDatabase() {
        // Get the path to the Documents directory
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access documents directory")
        }
        
        let databasePath = documentsDirectory.appendingPathComponent("database.db").path
        
        // Check if the database file already exists in the Documents directory
        if !fileManager.fileExists(atPath: databasePath) {
            // If it does not exist, copy it from the bundle
            guard let bundleDatabasePath = Bundle.main.path(forResource: "database", ofType: "db") else {
                fatalError("Db file not found in bundle")
            }
            
            do {
                try fileManager.copyItem(atPath: bundleDatabasePath, toPath: databasePath)
                print("Database file copied to documents directory")
            } catch {
                fatalError("Unable to copy database file: \(error.localizedDescription)")
            }
        } else {
            print("Database file already exists in documents directory")
        }
        
        // Open the database from the Documents directory
        dbManager.openDatabase(path: databasePath)
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        dbManager = DatabaseManager.shared
        initializeDatabase()
        createTestTables()
    }
    
    override func tearDownWithError() throws {
        dbManager = nil
        try super.tearDownWithError()
    }
    
    func createTestTables() {
        let createClientTable = """
        CREATE TABLE IF NOT EXISTS client (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            login TEXT,
            pass_hash TEXT,
            clinic_id INTEGER,
            name TEXT,
            address TEXT,
            address_coords TEXT
        );
        """
        
        let createClinicTable = """
        CREATE TABLE IF NOT EXISTS clinic (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            address TEXT,
            address_cords TEXT,
            is_pediatric INTEGER,
            is_hospital INTEGER
        );
        """
        
        let createDepartmentTable = """
        CREATE TABLE IF NOT EXISTS department (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            clinic_id INTEGER,
            specialization TEXT
        );
        """
        
        let createAppointmentTable = """
        CREATE TABLE IF NOT EXISTS appointment (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            client_id INTEGER,
            clinic_id INTEGER,
            department_id INTEGER,
            doctor_name TEXT,
            date TEXT
        );
        """
        
        dbManager.executeQuery(createClientTable)
        dbManager.executeQuery(createClinicTable)
        dbManager.executeQuery(createDepartmentTable)
        dbManager.executeQuery(createAppointmentTable)
    }

    func testAddAndGetDepartment() {
        let department = Department(id: 0, clinicId: 1, specialization: "Cardiology")
        dbManager.addDepartment(department)

        let fetchedDepartments = dbManager.getDepartmentsByClinicId(1)
        XCTAssertFalse(fetchedDepartments.isEmpty)
        XCTAssertEqual(fetchedDepartments.first?.specialization, "Cardiology")
    }

    func testAddAndGetAppointment() {
        let appointment = Appointment(id: 0, clientId: 1, clinicId: 1, departmentId: 1, doctorName: "Dr. Test", date: "2024-01-01")
        let appointmentId = dbManager.addAppointment(appointment)
        XCTAssertGreaterThan(appointmentId, 0)

        let fetchedAppointment = dbManager.getAppointmentById(appointmentId)
        XCTAssertNotNil(fetchedAppointment)
        XCTAssertEqual(fetchedAppointment?.doctorName, "Dr. Test")
    }

    func testDeleteAppointment() {
        let appointment = Appointment(id: 0, clientId: 1, clinicId: 1, departmentId: 1, doctorName: "Dr. Test", date: "2024-01-01")
        let appointmentId = dbManager.addAppointment(appointment)
        XCTAssertGreaterThan(appointmentId, 0)

        let deletionResult = dbManager.deleteAppointment(appointmentId)
        XCTAssertTrue(deletionResult)

        let fetchedAppointment = dbManager.getAppointmentById(appointmentId)
        XCTAssertNil(fetchedAppointment)
    }

    func testUpdateAppointmentDate() {
        let appointment = Appointment(id: 0, clientId: 1, clinicId: 1, departmentId: 1, doctorName: "Dr. Test", date: "2024-01-01 14:00")
        let appointmentId = dbManager.addAppointment(appointment)
        XCTAssertGreaterThan(appointmentId, 0)

        let newDate = "2024-02-01 14:00"
        let updateResult = dbManager.rescheduleAppointment(appointmentId: appointmentId, newDateString: newDate)
        XCTAssertTrue(updateResult)

        let fetchedAppointment = dbManager.getAppointmentById(appointmentId)
        XCTAssertNotNil(fetchedAppointment)
        XCTAssertEqual(fetchedAppointment?.date, newDate)
    }

    func testRescheduleAppointment() {
        let appointment = Appointment(id: 0, clientId: 1, clinicId: 1, departmentId: 1, doctorName: "Dr. Test", date: "2024-01-01")
        let appointmentId = dbManager.addAppointment(appointment)
        XCTAssertGreaterThan(appointmentId, 0)

        let newDate = "2024-02-01"
        let rescheduleResult = dbManager.rescheduleAppointment(appointmentId: appointmentId, newDateString: newDate)
        XCTAssertTrue(rescheduleResult)

        let fetchedAppointment = dbManager.getAppointmentById(appointmentId)
        XCTAssertNotNil(fetchedAppointment)
        XCTAssertEqual(fetchedAppointment?.date, newDate)
    }
}
