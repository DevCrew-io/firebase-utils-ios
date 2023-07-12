//
//  File.swift
//  
//
//  Created by Maaz Rafique on 07/07/2023.
//

import Foundation
import FirebaseDatabase

public class DBRef {
    public static let database = Database.database().reference()
}

public class DatabaseService {
    private let database = Database.database().reference()
    /// Initializes a new instance of DatabaseService.
    init() {
        
    }
    
    /// Adds a new data node to the database.
    ///
    /// - Parameters:
    ///   - path: The custom path for the data node. If not provided, a new reference with childByAutoId() will be generated.
    ///   - dataDic: The data to be added as a dictionary.
    ///   - dataObject: The data to be added as a custom object conforming to the `DatabaseNode` protocol.
    ///   - completion: The completion handler called with the result of the operation, containing the added data or an error.
    public func add<T: DatabaseNode>(path: DatabaseReference? = nil, dataDic: [String: Any]? = nil, dataObject: T? = nil, completion: @escaping (Result<T?, Error>) -> ()) {
        var dbRef = DatabaseReference()
        
        if let ref = path {
            dbRef = ref
        } else {
            dbRef = Database.database().reference().childByAutoId()
        }
        
        var nodeDic: [String: Any]?
        
        if let dataDic = dataDic {
            nodeDic = dataDic
        } else if let dataObject = dataObject {
            nodeDic = dataObject.toDictionary()
        }
        
        dbRef.setValue(nodeDic) { error, ref in
            // Observe the single event of childAdded to retrieve the newly added data
            dbRef.observeSingleEvent(of: .childAdded) { dataSnapshot in
                guard let value = dataSnapshot.value as? [String: Any] else {
                    return
                }
                guard let data = try? JSONSerialization.data(withJSONObject: value) else {
                    completion(.success(nil))  // Empty result if unable to serialize raw data
                    return
                }
                
                do {
                    var parsedObject = try JSONDecoder().decode(T.self, from: data)
                    parsedObject.nodeId = dataSnapshot.key
                    completion(.success(parsedObject))  // Completion handler with the retrieved document
                } catch {
                    completion(.failure(error))  // Handle decoding error
                }
            }
        }
    }

    /// Updates an existing data node in the database.
    ///
    /// - Parameters:
    ///   - ref: The reference to the data node to be updated.
    ///   - dataDic: The updated data as a dictionary.
    ///   - dataObject: The updated data as a custom object conforming to the `DatabaseNode` protocol.
    ///   - completion: The completion handler called with the result of the operation, containing the updated data or an error.
    public func update<T: DatabaseNode>(ref: DatabaseReference, dataDic: [String: Any]? = nil, dataObject: T? = nil, completion: @escaping (Result<T?, Error>) -> ()) {
        var nodeDic: [String: Any] = [:]
        
        if let dataDic = dataDic {
            nodeDic = dataDic
        } else if let dataObject = dataObject {
            nodeDic = dataObject.toDictionary() ?? [:]
        }
        
        ref.updateChildValues(nodeDic) { error, _ in
            // Observe the single event of childChanged to retrieve the updated data
            ref.observeSingleEvent(of: .childChanged) { dataSnapshot in
                guard let value = dataSnapshot.value as? [String: Any] else {
                    return
                }
                guard let data = try? JSONSerialization.data(withJSONObject: value) else {
                    completion(.success(nil))  // Empty result if unable to serialize raw data
                    return
                }
                
                do {
                    var parsedObject = try JSONDecoder().decode(T.self, from: data)
                    parsedObject.nodeId = dataSnapshot.key
                    completion(.success(parsedObject))  // Completion handler with the retrieved document
                } catch {
                    completion(.failure(error))  // Handle decoding error
                }
            }
        }
    }

    /// Retrieves a single object from the database.
    ///
    /// - Parameters:
    ///   - ref: The reference to the data node.
    ///   - eventType: The type of the data event to observe (e.g., .value, .childAdded).
    ///   - type: The type of the object to be retrieved, conforming to the `DatabaseNode` protocol.
    ///   - completion: The completion handler called with the result of the operation, containing the retrieved object or an error.
    public func getSingleObject<T: DatabaseNode>(ref: DatabaseReference, eventType: DataEventType, _ type: T.Type, completion: @escaping (_ result: Result<T?, Error>) -> ()) {
        // Observe a single event of the specified type to retrieve a single object
        ref.observeSingleEvent(of: eventType) { dataSnapshot in
            guard let value = dataSnapshot.value as? [String: Any] else {
                return
            }
            guard let data = try? JSONSerialization.data(withJSONObject: value) else {
                completion(.success(nil))  // Empty result if unable to serialize raw data
                return
            }
            
            do {
                var parsedObject = try JSONDecoder().decode(T.self, from: data)
                parsedObject.nodeId = dataSnapshot.key
                completion(.success(parsedObject))  // Completion handler with the retrieved document
            } catch {
                completion(.failure(error))  // Handle decoding error
            }
        }
    }

    /// Retrieves a list of objects from the database.
    ///
    /// - Parameters:
    ///   - ref: The reference to the data node.
    ///   - type: The type of the objects to be retrieved, conforming to the `DatabaseNode` protocol.
    ///   - completion: The completion handler called with the result of the operation, containing the retrieved list of objects or an error.
    public func getList<T: DatabaseNode>(ref: DatabaseReference, _ type: T.Type, completion: @escaping (_ result: Result<[T]?, Error>) -> ()) {
        ref.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                completion(.success(nil))
                return
            }
            if let dataSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                var resultArray: [T] = []
                for data in dataSnapshot {
                    let nodeId = data.key // Retrieve the node ID/key
                    if let dataObject = data.value as? [String: Any] {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: dataObject, options: [])
                            var parsedObject = try JSONDecoder().decode(type, from: data)
                            parsedObject.nodeId = nodeId
                            resultArray.append(parsedObject)
                        } catch {
                            debugPrint("error \(error.localizedDescription)")
                        }
                    }
                }
                // Handle completion with the retrieved list of objects
                completion(.success(resultArray))
            }
        }
    }

    /// Observes changes in a list of objects in the database.
    ///
    /// - Parameters:
    ///   - ref: The reference to the data node.
    ///   - type: The type of the objects to be observed, conforming to the `DatabaseNode` protocol.
    ///   - completion: The completion handler called with the result of the operation, containing the observed list of objects or an error.
    public func observe<T: DatabaseNode>(ref: DatabaseReference, _ type: T.Type, completion: @escaping (_ result: Result<[T]?, Error>) -> ()) {
        ref.observe(.value) { snapshot in
            if let dataSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                var resultArray:[T] = []
                    for data in dataSnapshot {
                        let nodeId = data.key // Retrieve the node ID/key
                        if let dataObject = data.value as? [String: Any] {
                            do {
                            let data = try JSONSerialization.data(withJSONObject: dataObject, options: [])
                            var parsedObject = try JSONDecoder().decode(type, from: data)
                                parsedObject.nodeId = nodeId
                                resultArray.append(parsedObject)
                        } catch {
                            debugPrint("error \(error.localizedDescription)")
                        }
                        }
                    }
                completion(.success(resultArray))
                }
        }
    }
    
    /// Observes changes in a list of objects in the database.
    ///
    /// - Parameters:
    ///   - ref: The reference to the data node.
    ///   - type: The type of the objects to be observed, conforming to the `DatabaseNode` protocol.
    ///   - completion: The completion handler called with the result of the operation, containing the observed object or an error.
    public func observeSingleObject<T: DatabaseNode>(ref: DatabaseReference, eventType: DataEventType, _ type: T.Type, completion: @escaping(_ result: Result<T?, Error>) -> ()) {
        ref.observeSingleEvent(of: eventType) { dataSnapshot  in
            guard let value = dataSnapshot.value as? [String: Any] else {
                return
            }
            guard let data = try? JSONSerialization.data(withJSONObject: value) else {
                completion(.success(nil))  // Empty result if unable to serialize raw data
                return
            }
            
            do {
                var parsedObject = try JSONDecoder().decode(T.self, from: data)
                parsedObject.nodeId = dataSnapshot.key
                completion(.success(parsedObject))  // Completion handler with the retrieved object
            } catch {
                completion(.failure(error))  // Handle decoding error
            }
        }
    }
    
    /// Observes changes in a list of objects in the database.
    ///
    /// - Parameters:
    ///   - ref: The reference to the data node.
    ///   - completion: The completion handler called with the result of the operation, containing an error if failed to remove.
    public func remove(ref: DatabaseReference, completion: @escaping(_ error: Error?) -> ()) {
        ref.removeValue { error, _ in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

}
