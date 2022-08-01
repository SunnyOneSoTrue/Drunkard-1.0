//
//  StorageManager.swift
//  Drunkard 1.0
//
//  Created by USER on 01.08.22.
//

import Foundation
import FirebaseStorage

final class storageManager {
    static let shared = storageManager()
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String,Error>) -> Void
    
    public func uploadProfilePicture(with Data: Data, filename: String, completion: @escaping UploadPictureCompletion){
        
        storage.child("images/\(filename)").putData(Data, metadata: nil) { metadata, error in
            guard error == nil else {
                //failed
                print("failed to upload picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(filename)").downloadURL { url, error in
                guard let url = url else {
                    print("failed to download url")
                    completion(.failure(StorageErrors.failedToDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("url string downloaded: \(urlString)")
                completion(.success(urlString))

            }
            
            
        }
        
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToDownloadURL
    }
}
