//
//  ValidatorTests.swift
//  Lab10Tests
//
//  Created by Yulia Raitsyna on 30.05.24.
//

import XCTest
@testable import Lab10

class ValidatorTests: XCTestCase {
    
    func testIsEmpty() {
        XCTAssertTrue(Validator.isEmpty(""))
        XCTAssertTrue(Validator.isEmpty("   "))
        XCTAssertTrue(Validator.isEmpty("\n\t"))
        XCTAssertFalse(Validator.isEmpty("a"))
        XCTAssertFalse(Validator.isEmpty(" some text "))
    }
    
    func testIsStrongPassword() {
        XCTAssertTrue(Validator.isStrongPassword("StrongP@ssword1"))
        XCTAssertTrue(Validator.isStrongPassword("Password123"))
        XCTAssertFalse(Validator.isStrongPassword("weak"))
        XCTAssertFalse(Validator.isStrongPassword("12345678"))
        XCTAssertFalse(Validator.isStrongPassword("password"))
        XCTAssertFalse(Validator.isStrongPassword("PASSWORD"))
    }
    
    func testPasswordsMatch() {
        XCTAssertTrue(Validator.passwordsMatch("password123", "password123"))
        XCTAssertFalse(Validator.passwordsMatch("password123", "password321"))
    }
    
    func testContainsOnlyLetters() {
        XCTAssertTrue(Validator.containsOnlyLetters("OnlyLetters"))
        XCTAssertTrue(Validator.containsOnlyLetters("Letters"))
        XCTAssertFalse(Validator.containsOnlyLetters("123"))
        XCTAssertFalse(Validator.containsOnlyLetters("Letters123"))
        XCTAssertFalse(Validator.containsOnlyLetters("Letters with spaces"))
        XCTAssertFalse(Validator.containsOnlyLetters("!@#"))
    }
    
    func testContainsOnlyNumbers() {
        XCTAssertTrue(Validator.containsOnlyNumbers("123456"))
        XCTAssertFalse(Validator.containsOnlyNumbers("123abc"))
        XCTAssertFalse(Validator.containsOnlyNumbers("abc"))
        XCTAssertFalse(Validator.containsOnlyNumbers("123 456"))
        XCTAssertFalse(Validator.containsOnlyNumbers("123!@#"))
    }
}
