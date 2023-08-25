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
        ///   - metaData: Optional metadata for the uploaded file.
        ///   - progressCompletion: A closure that gets called with the upload progress.
        ///   - completion: A closure that gets called upon completion with the result of the operation.
        /// - Returns: A `StorageUploadTask` instance for managing the upload task.
    public func upload(file data: Data, with name: String, in folder: String, metaData: StorageMetadata?, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) -> StorageUploadTask {
        putDataRequest(data, with: name, in: folder, metaData: metaData, progressCompletion: progressCompletion, completion: completion)
    }
            
        /// Updates a file to the specified folder in Firebase Storage.
        ///
        /// - Parameters:
        ///   - data: The data of the file to be uploaded.
        ///   - name: The name of the file.
        ///   - folder: The folder path in Firebase Storage where the file should be uploaded.
        ///   - metaData: Optional metadata for the uploaded file.
        ///   - progressCompletion: A closure that gets called with the upload progress.
        ///   - completion: A closure that gets called upon completion with the result of the operation.
        /// - Returns: A `StorageUploadTask` instance for managing the upload task.
    public func update(file data: Data, with name: String, in folder: String, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) -> StorageUploadTask {
        return putDataRequest(data, with: name, in: folder, metaData: nil, progressCompletion: progressCompletion, completion: completion)
    }
    
        
        /// Uploads a file to the specified folder in Firebase Storage.
        ///
        /// - Parameters:
        ///   - url: The local url of the file to be uploaded.
        ///   - name: The name of the file.
        ///   - folder: The folder path in Firebase Storage where the file should be uploaded.
        ///   - metaData: Optional metadata for the uploaded file.
        ///   - progressCompletion: A closure that gets called with the upload progress.
        ///   - completion: A closure that gets called upon completion with the result of the operation.
        /// - Returns: A `StorageUploadTask` instance for managing the upload task.
    
    public func upload(file url: URL, with name: String, in folder: String, metaData: StorageMetadata?, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) -> StorageUploadTask {
        putFileRequest(url, with: name, in: folder, metaData: metaData, progressCompletion: progressCompletion, completion: completion)
    }
    
        
        /// Updates a file to the specified folder in Firebase Storage.
        ///
        /// - Parameters:
        ///   - url: The local url of the file to be uploaded.
        ///   - name: The name of the file.
        ///   - folder: The folder path in Firebase Storage where the file should be uploaded.
        ///   - metaData: Optional metadata for the uploaded file.
        ///   - progressCompletion: A closure that gets called with the upload progress.
        ///   - completion: A closure that gets called upon completion with the result of the operation.
        /// - Returns: A `StorageUploadTask` instance for managing the upload task.
    public func update(file url: URL, with name: String, in folder: String, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) -> StorageUploadTask {
        return putFileRequest(url, with: name, in: folder,metaData: nil, progressCompletion: progressCompletion, completion: completion)
    }
    
        /// Downloads data from the specified path in Firebase Storage.
        ///
        /// - Parameters:
        ///   - path: The path to the file in Firebase Storage.
        ///   - size: The maximum size of data to download.
        ///   - progressCompletion: A closure that gets called with the download progress.
        ///   - completion: A closure that gets called upon completion with the result of the operation.
        /// - Returns: A `StorageDownloadTask` instance for managing the download task.
    
    public func downloadData(from path: String, size: Int64 = Int64.max, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<Data?, Error>) -> Void) -> StorageDownloadTask {
        
        return downloadDataRequest(from: path, size: size, progressCompletion: progressCompletion, completion: completion)
        
    }
    
    /// Downloads file from the specified path to local path in Firebase Storage.
    ///
    /// - Parameters:
    ///   - path: The path to the file in Firebase Storage.
    ///   - size: The maximum size of data to download.
    ///   - localURL: The url of file in local directory
    ///   - progressCompletion: A closure that gets called with the download progress.
    ///   - completion: A closure that gets called upon completion with the result of the operation.
    /// - Returns: A `StorageDownloadTask` instance for managing the download task.
    public func downloadFile(from path: String, to localURL: URL, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<URL?, Error>) -> Void) -> StorageDownloadTask {
        return downloadFileRequest(from: path, to: localURL, progressCompletion: progressCompletion, completion: completion)
    }
    
    /// Downloads file downloadable url from Firebase Storage.
    ///
    /// - Parameters:
    ///   - path: The path to the file in Firebase Storage.
    ///   - completion: A closure that gets called upon completion with the result of the operation.
    /// - Returns: A `StorageDownloadTask` instance for managing the download task.
    public func downloadURL(for path: String, completion: @escaping (_ result:  Result<URL?, Error>) -> Void) {
        return downloadURLRequest(for: path, completion: completion)
    }
    
    /// Retrieves metadata for a file in Firebase Storage.
        ///
        /// - Parameters:
        ///   - path: The path to the file in Firebase Storage.
        ///   - completion: A closure that gets called upon completion with the result of the operation.
    public func getMetadata(for path: String, completion: @escaping(_ result:  Result<StorageMetadata?, Error>) -> ()) {
        getMetadataRequest(for: path, completion: completion)
    }
    
    /// adds metadata for a file in Firebase Storage.
        ///
        /// - Parameters:
        ///   - metaData: The metadata to be added to added path
        ///   - path: The path to the file in Firebase Storage.
        ///   - completion: A closure that gets called upon completion with the result of the operation.
    public func create(file metaData: StorageMetadata, for path: String, completion: @escaping(_ result: Result<StorageMetadata?, Error>) -> ()) {
        updateMetaDataRequest(file: metaData, for: path, completion: completion)
    }
    
    /// updates metadata for a file in Firebase Storage.
        ///
        /// - Parameters:
        ///   - metaData: The metadata to be added to added path
        ///   - path: The path to the file in Firebase Storage.
        ///   - completion: A closure that gets called upon completion with the result of the operation.
    public func update(file metaData: StorageMetadata, for path: String, completion: @escaping(_ result: Result<StorageMetadata?, Error>) -> ()) {
        updateMetaDataRequest(file: metaData, for: path, completion: completion)
    }
    
    /// deletes metadata for a file in Firebase Storage.
        ///
        /// - Parameters:
        ///   - path: The path to the file in Firebase Storage.
        ///   - completion: A closure that gets called upon completion with the result of the operation.
    public func deleteMetadata(for path: String, completion: @escaping(_ result: Result<StorageMetadata?, Error>) -> ()) {
        
        var metaData = StorageMetadata()

        updateMetaDataRequest(file: metaData, for: path, completion: completion)
    }
    
    public func getAllFiles(in folderPath: String, completion: @escaping (Result<[StorageReference]?, Error>) -> Void) {
        getAllFilesRequest(in: folderPath, completion: completion)
    }
    
    public func getFiles(in folderPath: String, pageToken: String, pageSize: Int64 = 20, completion: @escaping (Result<(items: [StorageReference]?, nextPageToken: String?), Error>) -> Void) {
        getFilesRequest(in: folderPath, pageToken: pageToken, completion: completion)
    }
    
    /// Deletes a file from Firebase Storage.
    ///
    /// - Parameters:
    ///   - url: The URL of the file to be deleted.
    ///   - completion: A closure that gets called upon completion with the result of the operation.
    public func delete(file path: String, colletion: String, completion: @escaping (_ result: Result<Bool?, Error>) -> ()) {
        deleteRequest(file: path, colletion: colletion, completion: completion)
    }
    // MARK: - Private Helper Functions
    
    // Helper function for uploading data

    private func putDataRequest(_ data: Data, with name: String, in folder: String, metaData: StorageMetadata?, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) -> StorageUploadTask {
        let uploadTask = storage.child("\(folder)/\(name)").putData(data, metadata: metaData) { metaData, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.storage.child(metaData?.path ?? "").downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success((url?.absoluteString, metaData?.name)))
                    }
                }
            }
        }
        
        uploadTask.observe(.progress) { storageSnapshot  in
            guard let progress = storageSnapshot.progress else { return }
            progressCompletion(progress)
        }


        return uploadTask
    }
    
    // Helper function for uploading file with url

    private func putFileRequest(_ url: URL, with name: String, in folder: String, metaData: StorageMetadata?, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<(String?, String?), Error>) -> ()) -> StorageUploadTask {
        let uploadTask = storage.child("\(folder)/\(name)").putFile(from: url, metadata: metaData) { metaData, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.storage.child(metaData?.path ?? "").downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success((url?.absoluteString, metaData?.name)))
                    }
                }
            }
        }
        
        uploadTask.observe(.progress) { storageSnapshot  in
            guard let progress = storageSnapshot.progress else { return }
            progressCompletion(progress)
        }


        return uploadTask
    }
    
    // Helper function for downloading data

    private func downloadDataRequest(from path: String, size: Int64 = Int64.max, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<Data?, Error>) -> Void) -> StorageDownloadTask {
        
        let downloadTask = storage.child(path).getData(maxSize: size) { data, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        }
        
        downloadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            progressCompletion(progress)
        }
        return downloadTask
    }
    
    // Helper function for downloading file

    private func downloadFileRequest(from path: String, to localURL: URL, progressCompletion: @escaping (_ progress: Progress) -> (), completion: @escaping (_ result: Result<URL?, Error>) -> Void) -> StorageDownloadTask {
        
        let downloadTask = storage.child(path).write(toFile: localURL) { url, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(url))
            }
        }
        
        downloadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            progressCompletion(progress)
        }
        return downloadTask
        
    }
    // Helper function for downloading url

    private func downloadURLRequest(for path: String, completion: @escaping (_ result: Result<URL?, Error>) -> Void) {
        
        storage.child(path).downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(url))
            }
        }
        
    }
    
    // Helper function for fetching metadata

    private func getMetadataRequest(for path: String, completion: @escaping(_ result: Result<StorageMetadata?, Error>) -> ()) {
        storage.child(path).getMetadata { metadata, error in
          if let error = error {
              completion(.failure(error))
          } else {
              completion(.success(metadata))
          }
        }
    }
    
    // Helper function for update data

    private func updateMetaDataRequest(file metaData: StorageMetadata, for path: String, completion:@escaping(_ result: Result<StorageMetadata?, Error>) -> ()) {
        storage.child(path).updateMetadata(metaData) { metadata, error in
          if let error = error {
              completion(.failure(error))
          } else {
              completion(.success(metadata))
          }
        }
    }
    
    // Helper function for retrieving all list of files
    
    private func getAllFilesRequest(in folderPath: String, completion: @escaping (Result<[StorageReference]?, Error>) -> Void) {
        
         storage.child(folderPath).listAll { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(result?.items))
            }
        }
    }
    
    // Helper function for retrieving list of files with pagination

    private func getFilesRequest(in folderPath: String, pageToken: String, pageSize: Int64 = 20, completion: @escaping (Result<(items: [StorageReference]?, nextPageToken: String?), Error>) -> Void) {
        
        storage.child(folderPath).list(maxResults: pageSize, pageToken: pageToken) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success((items: result?.items, nextPageToken: result?.pageToken)))
            }
        }
    }
    
    // Helper function for deleting file
    
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
