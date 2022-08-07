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
    
    static func safeEmail(email:String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "^")
        return safeEmail
    }
}


//MARK: ACCOUNT MANAGEMENT
extension DatabaseManager {
    ///inserts the user into the database with the provided users information
    public func insertUser(with user: user, completion: @escaping (Bool) -> Void){
        
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
            "phone_number": user.phoneNumber
        ]) { error, _ in
            guard error == nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value, with: {snapshot in
                if var usersCollection = snapshot.value as? [[String:String]] {
                    //append to user dictionary
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail,
                        "phone number": user.phoneNumber
                    ]
                    
                    usersCollection.append(contentsOf: newElement)
                    
                    self.database.child("users").setValue(usersCollection, withCompletionBlock: {error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    })
                }
                else {
                    //create that array
                    let newCollection: [[String:String]] = [
                        [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail,
                        "phone number": user.phoneNumber
                        ]
                    ]
                    
                    self.database.child("users").setValue(newCollection, withCompletionBlock: {error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    })
                }
            })
            
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
    
    var backgroundPictureName :String {
        return ("\(safeEmail)_background_picture.png")
    }
}
