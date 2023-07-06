//
//  File.swift
//  
//
//  Created by Maaz Rafique on 06/07/2023.
//

import Foundation
import FirebaseStorage

public class StorageService {
    private let storage = Storage.storage().reference()
    
    /// Initializes a new instance of StorageService.
    init() {
        
    }
    
    /// Uploads a file to the specified folder in Firebase Storage.
    ///
    /// - Parameters:
    ///   - data: The data of the file to be uploaded.
    ///   - name: The name of the file.
    ///   - folder: The folder path in Firebase Storage where the file should be uploaded.
    ///   - completion: A closure that gets called upon completion with the result of the operation.
    public func upload(file data: Data, with name: String, in folder: String, completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) {
        storage.child("\(folder)/\(name)").putData(data) { metaData, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success((metaData?.path, metaData?.name)))
            }
        }
    }
    
    /// Updates a file in the specified folder in Firebase Storage.
    ///
    /// - Parameters:
    ///   - data: The updated data of the file.
    ///   - name: The name of the file.
    ///   - folder: The folder path in Firebase Storage where the file is located.
    ///   - completion: A closure that gets called upon completion with the result of the operation.
    public func update(file data: Data, with name: String, in folder: String, completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) {
        storage.child("\(folder)/\(name)").putData(data) { metaData, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success((metaData?.path,metaData?.name)))
            }
        }
    }
    
    /// Deletes a file from Firebase Storage.
    ///
    /// - Parameters:
    ///   - url: The URL of the file to be deleted.
    ///   - completion: A closure that gets called upon completion with the result of the operation.
    public func delete(file url: String, completion: @escaping (_ result: Result<Bool?, Error>) -> ()) {
        storage.child(url).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
}
