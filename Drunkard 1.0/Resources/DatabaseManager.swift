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
    public func insertUser(with user: user, completion: @escaping (Bool) -> Void){
        
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
            "phone_number": user.phoneNumber
//            "profilePictureURL":user.profilePictureURL
        ]) { error, _ in
            guard error == nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
}

struct user {
    let firstName: String
    let lastName:String
    let phoneNumber:String
    let email:String
    
    var safeEmail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "^")
        return safeEmail
    }
    
    var profilePictureFileName :String {
        return "\(safeEmail)_profile_picture.png"
    }
}
