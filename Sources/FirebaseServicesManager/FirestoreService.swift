//
//  File.swift
//
//
//  Created by Maaz Rafique on 03/05/2023.
//

import Foundation
import FirebaseFirestore

public class FSQuery {
    public static let firestore = Firestore.firestore()
}

/// Service class for interacting with Firestore.
public class FirestoreService {
    private let firestore = Firestore.firestore()
    /// Initializes a new instance of FirestoreService.
    init() {
        
    }
    
    /// Adds a document to the specified collection in Firestore.
    ///
    /// - Parameters:
    ///   - collectionPath: The path of the collection where the document will be added.
    ///   - dataDic: Optional dictionary representing the data to be added to the document. Default is `nil`.
    ///   - dataObject: Optional custom object conforming to `FirestoreDocument` that will be converted to a dictionary and added to the document. Default is `nil`.
    ///   - completion: A closure to be called when the operation is completed, containing a result of type `Result<T?, Error>`.
    public func add<T: FirestoreDocument>(documentAt collectionPath: String, dataDic: [String: Any]? = nil, dataObject: T? = nil, completion: @escaping(Result<T?, Error>) -> ()) {
        addRequest(documentAt: collectionPath, completion: completion)
    }
    
    /// Retrieves a list of documents from Firestore based on the provided query.
    ///
    /// - Parameters:
    ///   - type: The type of the documents to retrieve, conforming to `FirestoreDocument`.
    ///   - query: The Firestore query used to retrieve the documents.
    ///   - completion: A closure to be called when the operation is completed, containing a result of type `Result<[T], Error>`.
    public func getList<T: FirestoreDocument>(_ type: T.Type, firestore query: Query, completion: @escaping(Result<[T], Error>) -> ()) {
        getListRequest(type, firestore: query, completion: completion)
    }
    
    /// Retrieves a specific document from Firestore based on the provided document ID and collection.
    ///
    /// - Parameters:
    ///   - id: The ID of the document to retrieve.
    ///   - collection: The name of the collection containing the document.
    ///   - type: The type of the document to retrieve, conforming to `FirestoreDocument`.
    ///   - completion: A closure to be called when the operation is completed, containing a result of type `Result<T?, Error>`.
    public func getDocument<T: FirestoreDocument>(with id: String, from collection: String, _ type: T.Type, completion: @escaping(Result<T?, Error>) -> ()) {
        getDocumentRequest(with: id, from: collection, type, completion: completion)
    }
    
    /// Observes changes to a collection in Firestore based on the provided query and returns an array of documents of type `T`.
    ///
    /// - Parameters:
    ///   - query: The Firestore query used to observe the collection.
    ///   - type: The type of the documents to observe, conforming to `FirestoreDocument`.
    ///   - completion: A closure to be called when changes occur, containing a result of type `Result<[T], Error>`.
    public func observeDocuments<T: FirestoreDocument>(query: Query, _ type: T.Type, completion: @escaping(Result<[T], Error>) -> ()) {
        observeDocumentsRequest(query: query, type, completion: completion)
    }
    
    /// Observes changes to a specific document in Firestore based on the provided document ID and collection, and returns the document of type `T`.
    ///
    /// - Parameters:
    ///   - id: The ID of the document to observe.
    ///   - collection: The collection where the document resides.
    ///   - type: The type of the document to observe, conforming to `FirestoreDocument`.
    ///   - completion: A closure to be called when changes occur, containing a result of type `Result<T, Error>`.
    public func observeDocument<T: FirestoreDocument>(with id: String, from collection: String, _ type: T.Type, completion: @escaping(Result<T?,Error>) -> ()) {
        observeDocumentRequest(with: id, from: collection, type, completion: completion)
    }
    
    /// Updates a document in Firestore with the provided ID and collection path, using either a dictionary or an object conforming to `FirestoreDocument`.
    ///
    /// - Parameters:
    ///   - id: The ID of the document to update.
    ///   - collectionPath: The path of the collection where the document resides.
    ///   - dataDic: Optional. A dictionary containing the updated data to be applied to the document.
    ///   - dataObject: Optional. An object conforming to `FirestoreDocument` that will be converted to a dictionary to update the document.
    ///   - completion: A closure to be called upon completion of the update operation, containing a result of type `Result<T?, Error>`.
    public func update<T: FirestoreDocument>(with id: String, documentIn collectionPath: String, dataDic: [String: Any]? = nil, dataObject: T? = nil, completion: @escaping(Result<T?,Error>) -> ()) {
        updateRequest(with: id, documentIn: collectionPath, completion: completion)
    }
    
    /// Deletes a document from Firestore with the provided ID and collection path.
    ///
    /// - Parameters:
    ///   - id: The ID of the document to delete.
    ///   - collectionPath: The path of the collection where the document resides.
    ///   - completion: A closure to be called upon completion of the delete operation, containing a result of type `Result<Bool, Error>`.
    public func delete(id: String, documentAt collectionPath: String, completion: @escaping(Result<Bool,Error>) -> ()) {
        deleteRequest(id: id, documentAt: collectionPath, completion: completion)
    }
    // MARK: - Private Function
    private func addRequest<T: FirestoreDocument>(documentAt collectionPath: String, dataDic: [String: Any]? = nil, dataObject: T? = nil, completion: @escaping(Result<T?, Error>) -> ()) {
        let fsRef = firestore.collection(collectionPath)  // Reference to the collection
        var ref: DocumentReference? = nil
        var documentDic: [String: Any]?
        
        // Check if data is provided as a dictionary or a custom object
        if let dataDic = dataDic {
            documentDic = dataDic
        } else if let dataObject = dataObject {
            documentDic = dataObject.toDictionary()
        }
        
        // Add the document to the collection
        ref = fsRef.addDocument(data: documentDic ?? [:]) { err in
            if let err = err {
                completion(.failure(err))  // Handle the error if any
            } else {
                guard let docId = ref?.documentID else {
                    completion(.success(nil))
                    return
                }
                
                guard var dataObject = dataObject else {
                    completion(.success(nil))
                    return
                }
                
                dataObject.docId = docId  // Set the document ID for the data object
                completion(.success(dataObject))  // Completion handler with the added document
            }
        }
    }
    private func getListRequest<T: FirestoreDocument>(_ type: T.Type, firestore query: Query, completion: @escaping(Result<[T], Error>) -> ()) {
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))  // Handle the error if any
            } else if let snapshot = snapshot {
                guard !snapshot.documents.isEmpty else {
                    completion(.success([]))  // Empty result if no documents found
                    return
                }
                
                let documents = snapshot.documents
                let parsedData: [T] = documents.compactMap {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: $0.data(), options: [])
                        var parsedObject = try JSONDecoder().decode(type, from: data)
                        parsedObject.docId = $0.documentID
                        return parsedObject
                    } catch {
                        return nil
                    }
                }
                
                completion(.success(parsedData))  // Completion handler with the retrieved documents
            }
        }
    }
    private func getDocumentRequest<T: FirestoreDocument>(with id: String, from collection: String, _ type: T.Type, completion: @escaping(Result<T?, Error>) -> ()) {
        let fsRef = firestore.collection(collection).document(id)
        fsRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))  // Handle the error if any
            } else {
                guard let document = document, let rawObject = document.data() else {
                    completion(.success(nil))  // Empty result if document or raw data is nil
                    return
                }
                
                guard let data = try? JSONSerialization.data(withJSONObject: rawObject) else {
                    completion(.success(nil))  // Empty result if unable to serialize raw data
                    return
                }
                
                do {
                    var parsedObject = try JSONDecoder().decode(T.self, from: data)
                    parsedObject.docId = document.documentID
                    completion(.success(parsedObject))  // Completion handler with the retrieved document
                } catch {
                    completion(.failure(error))  // Handle decoding error
                }
            }
        }
    }
    private func observeDocumentsRequest<T: FirestoreDocument>(query: Query, _ type: T.Type, completion: @escaping(Result<[T], Error>) -> ()) {
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))  // Handle the error if any
            } else if let snapshot = snapshot {
                guard !snapshot.documents.isEmpty else {
                    completion(.success([]))  // Empty result if there are no documents
                    return
                }
                
                let documents = snapshot.documents
                let parsedData: [T] = documents.compactMap {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: $0.data(), options: [])
                        var parsedObject = try JSONDecoder().decode(type, from: data)
                        parsedObject.docId = $0.documentID
                        return parsedObject
                    } catch {
                        return nil  // Skip document if decoding fails
                    }
                }
                
                completion(.success(parsedData))  // Completion handler with the parsed documents
            }
        }
    }
    private func observeDocumentRequest<T: FirestoreDocument>(with id: String, from collection: String, _ type: T.Type, completion: @escaping(Result<T?,Error>) -> ()) {
        firestore.collection(collection).document(id).addSnapshotListener { docSnap, error in
            if let error = error {
                completion(.failure(error))  // Handle the error if any
            } else if let docSnap = docSnap, let rawObject = docSnap.data() {
                do {
                    let data = try JSONSerialization.data(withJSONObject: rawObject, options: [])
                    var parsedObject = try JSONDecoder().decode(type, from: data)
                    parsedObject.docId = docSnap.documentID
                    completion(.success(parsedObject))  // Completion handler with the parsed document
                } catch {
                    completion(.failure(error))  // Handle the decoding error
                }
            } else {
                completion(.failure(error!))  // Handle the case when the document snapshot is nil
            }
        }
    }
    private func updateRequest<T: FirestoreDocument>(with id: String, documentIn collectionPath: String, dataDic: [String: Any]? = nil, dataObject: T? = nil, completion: @escaping(Result<T?,Error>) -> ()) {
        let fsRef = firestore.collection(collectionPath).document(id)
        var documentDic: [String: Any]?
        
        if let dataDic = dataDic {
            documentDic = dataDic
        } else if let dataObject = dataObject {
            documentDic = dataObject.toDictionary()
        }
        
        fsRef.updateData(documentDic ?? [:]) { err in
            if let err = err {
                completion(.failure(err))  // Handle the error if any
            } else {
                completion(.success(dataObject))  // Completion handler with the updated document object
            }
        }
    }
    private func deleteRequest(id: String, documentAt collectionPath: String, completion: @escaping(Result<Bool,Error>) -> ()) {
        let fsRef = firestore.collection(collectionPath).document(id)
        
        fsRef.delete { err in
            if let err = err {
                completion(.failure(err))  // Handle the error if any
            } else {
                completion(.success(true))  // Completion handler indicating successful deletion
            }
        }
    }
}

