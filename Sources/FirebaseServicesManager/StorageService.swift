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
        uploadRequest(file: data, with: name, in: folder, completion: completion)
    }
    
    /// Updates a file in the specified folder in Firebase Storage.
    ///
    /// - Parameters:
    ///   - data: The updated data of the file.
    ///   - name: The name of the file.
    ///   - folder: The folder path in Firebase Storage where the file is located.
    ///   - completion: A closure that gets called upon completion with the result of the operation.
    public func update(file data: Data, with name: String, in folder: String, completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) {
        updateRequest(file: data, with: name, in: folder, completion: completion)
    }
    
    /// Deletes a file from Firebase Storage.
    ///
    /// - Parameters:
    ///   - url: The URL of the file to be deleted.
    ///   - completion: A closure that gets called upon completion with the result of the operation.
    public func delete(file path: String, colletion: String, completion: @escaping (_ result: Result<Bool?, Error>) -> ()) {
        deleteRequest(file: path, colletion: colletion, completion: completion)
    }
    // MARK: - Private function -
    private func uploadRequest(file data: Data, with name: String, in folder: String, completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) {
        storage.child("\(folder)/\(name)").putData(data) {[weak self] metaData, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self?.storage.child(metaData?.path ?? "").downloadURL(completion: { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success((url?.absoluteString, metaData?.name)))                    }
                })
            }
        }
    }
    private func updateRequest(file data: Data, with name: String, in folder: String, completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) {
        storage.child("\(folder)/\(name)").putData(data) {[weak self] metaData, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self?.storage.child(metaData?.path ?? "").downloadURL(completion: { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success((url?.absoluteString, metaData?.name)))                    }
                })
            }
        }
    }
    private func deleteRequest(file path: String, colletion: String, completion: @escaping (_ result: Result<Bool?, Error>) -> ()) {
        storage.child("\(colletion)/\(path)").delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }

}
