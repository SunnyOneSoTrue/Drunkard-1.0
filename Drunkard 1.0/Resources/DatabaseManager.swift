//
//  DatabaseManager.swift
//  Drunkard 1.0
//
//  Created by USER on 18.03.22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}


//MARK: ACCOUNT MANAGEMENT
extension DatabaseManager {
    ///inserts the user into the database with the provided users information
    public func insertUser(with user: user){
        var usableEmail = ""
        
        for letter in user.email {
            if letter == "."{
                usableEmail += "^"
            }
            else {
                usableEmail += String(letter)
            }
        }
        
        database.child(usableEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
            "phone_number": user.phoneNumber
//            "profilePictureURL":user.profilePictureURL
        ])
    }
    
}

struct user {
    let firstName: String
    let lastName:String
    let email:String
    let phoneNumber:String
//    let profilePictureURL:String
}
