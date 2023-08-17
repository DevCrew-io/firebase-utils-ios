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
    private static let nodeId = "nodeId"
    /// Initializes a new instance of DatabaseService.
    init() {
        
    }
    
    /// Adds a new data node to the database.
    ///
    /// - Parameters:
    ///   - path: The custom path for the data node. If not provided, a new reference with childByAutoId() will be generated.
    ///   - dataDic: The data to be added as a dictionary.
    ///   - completion: The completion handler called with the result of the operation, containing the added data or an error.
    public func add(ref: DatabaseReference, dataDic: [String: Any], completion: @escaping (Result<[String: Any]?, Error>) -> ()) {
        addRequest(ref: ref, dataDic: dataDic, completion: completion)
    }
    
    /// Adds a new data node to the database.
    ///
    /// - Parameters:
    ///   - path: The custom path for the data node. If not provided, a new reference with childByAutoId() will be generated.
    ///   - dataObject: The data to be added as a custom object conforming to the `DatabaseNode` protocol.
    ///   - completion: The completion handler called with the result of the operation, containing the added data or an error.
    public func add<T: DatabaseNode>(ref: DatabaseReference, dataObject: T, completion: @escaping (Result<T?, Error>) -> ()) {
        addRequest(ref: ref, dataObject: dataObject, completion: completion)
    }
    
    /// Updates an existing data node in the database.
    ///
    /// - Parameters:
    ///   - ref: The reference to the data node to be updated.
    ///   - dataDic: The updated data as a dictionary.
    ///   - completion: The completion handler called with the result of the operation, containing the updated data or an error.
    public func update(ref: DatabaseReference, dataDic: [String: Any], completion: @escaping (Result<[String: Any]?, Error>) -> ()) {
        updateRequest(ref: ref, dataDic: dataDic, completion: completion)
    }
    
    /// Updates an existing data node in the database.
    ///
    /// - Parameters:
    ///   - ref: The reference to the data node to be updated.
    ///   - dataObject: The updated data as a custom object conforming to the `DatabaseNode` protocol.
    ///   - completion: The completion handler called with the result of the operation, containing the updated data or an error.
    public func update<T: DatabaseNode>(ref: DatabaseReference, dataObject: T, completion: @escaping (Result<T?, Error>) -> ()) {
        updateRequest(ref: ref, dataObject: dataObject, completion: completion)
    }
    
    /// Retrieves a single object from the database.
    ///
    /// - Parameters:
    ///   - ref: The reference to the data node.
    ///   - eventType: The type of the data event to observe (e.g., .value, .childAdded).
    ///   - completion: The completion handler called with the result of the operation, containing the retrieved object or an error.
    public func getSingleObject<T: DatabaseNode>(ref: DatabaseReference, eventType: DataEventType = .value, completion: @escaping (_ result: Result<T?, Error>) -> ()) {
        getSingleObjectRequest(ref: ref, eventType: eventType, completion: completion)
    }
    
    /// Retrieves a list of objects from the database.
    ///
    /// - Parameters:
    ///   - ref: The reference to the data node.
    ///   - completion: The completion handler called with the result of the operation, containing the retrieved list of objects or an error.
    public func getList<T: DatabaseNode>(ref: DatabaseReference, completion: @escaping (_ result: Result<[T]?, Error>) -> ()) {
        getListRequest(ref: ref, completion: completion)
    }
    
    /// Observes changes in a list of objects in the database.
    ///
    /// - Parameters:
    ///   - ref: The reference to the data node.
    ///   - completion: The completion handler called with the result of the operation, containing the observed list of objects or an error.
    public func observeList<T: DatabaseNode>(ref: DatabaseReference, completion: @escaping (_ result: Result<[T]?, Error>) -> ()) -> UInt {
        return observeListRequest(ref: ref, completion: completion)
    }
    
    public func observeSingleObject<T: DatabaseNode>(ref: DatabaseReference, completion: @escaping (_ result: Result<T?, Error>) -> ()) -> UInt {
        return observeSingleObjectRequest(ref: ref, eventType: .value, T.self, completion: completion)
    }
    
    public func getData(ref: DatabaseReference, completion: @escaping(_ result: Result<DataSnapshot?, Error>) -> ()) {
        getDataRequest(ref: ref, completion: completion)
    }
    
    
    /// Observes changes in a list of objects in the database.
    ///
    /// - Parameters:
    ///   - ref: The reference to the data node.
    ///   - completion: The completion handler called with the result of the operation, containing an error if failed to remove.
    public func remove(ref: DatabaseReference, completion: @escaping(_ error: Error?) -> ()) {
        removeRequest(ref: ref, completion: completion)
    }
    
    /// Removes all the  registered observers.
    ///
    /// - Parameters:
    ///   - ref: The optional reference to the DatabaseReference. If provided, the observers associated with the specific DatabaseReference will be removed. If not provided, observers associated with the default DatabaseReference will be removed.
    public func removeAllObservers(ref: DatabaseReference? = nil) {
        removeAllHandles(ref)
    }
    
    ///  Removes the observers associated with the specified handles.
    ///
    /// - Parameters:
    ///   - handles: An array of UInt values representing the handles of the observers to be removed.
    ///   - ref: The optional reference to the DatabaseReference. If provided, the observers associated with the specific DatabaseReference will be removed. If not provided, observers associated with the default DatabaseReference will be removed.
    public func removeObservers(withHandles handles: [UInt], ref: DatabaseReference? = nil) {
        removeHandles(ref, handles)
    }
    
    
    // MARK: - Private Function -
    private func addRequest(ref: DatabaseReference, dataDic: [String: Any], completion: @escaping (Result<[String: Any]?, Error>) -> ()) {
        var nodeDic = dataDic
        nodeDic.removeValue(forKey: DatabaseService.nodeId)
        ref.setValue(nodeDic) { error, ref in
            guard let error = error else {
                nodeDic[DatabaseService.nodeId] = ref.key
                completion(.success(nodeDic))
                return
            }
            completion(.failure(error))
        }
    }
    
    private func addRequest<T: DatabaseNode>(ref: DatabaseReference, dataObject: T, completion: @escaping (Result<T?, Error>) -> ()) {
        var nodeDic = dataObject.toDictionary() ?? [:]
        nodeDic.removeValue(forKey: DatabaseService.nodeId)
        ref.setValue(nodeDic) { error, ref in
            guard let error = error else {
                guard let data = try? JSONSerialization.data(withJSONObject: nodeDic) else {
                    completion(.success(nil))  // Empty result if unable to serialize raw data
                    return
                }

                do {
                    var parsedObject = try JSONDecoder().decode(T.self, from: data)
                    parsedObject.nodeId = ref.key
                    completion(.success(parsedObject))  // Completion handler with the retrieved document
                } catch {
                    completion(.failure(error))  // Handle decoding error
                }
                return
            }
            completion(.failure(error))
        }
    }
    
    private func updateRequest(ref: DatabaseReference, dataDic: [String: Any], completion: @escaping (Result<[String: Any]?, Error>) -> ()) {
        var nodeDic = dataDic
        nodeDic.removeValue(forKey: DatabaseService.nodeId)
        ref.updateChildValues(nodeDic) { error, _ in
            guard let error = error else {
                ref.observeSingleEvent(of: .value) { dataSnapshot in
                    guard var nodeDic = dataSnapshot.value as? [String: Any] else {
                        completion(.success(nil))  // Empty result
                        return
                    }
                    
                    nodeDic[DatabaseService.nodeId] = dataSnapshot.key
                    completion(.success(nodeDic))
                }
                return
            }
            completion(.failure(error))
        }
    }
    
    private func updateRequest<T: DatabaseNode>(ref: DatabaseReference, dataObject: T? = nil, completion: @escaping (Result<T?, Error>) -> ()) {
        var nodeDic = dataObject.toDictionary() ?? [:]
        nodeDic.removeValue(forKey: DatabaseService.nodeId)
        ref.updateChildValues(nodeDic) {[weak self] error, _ in
            guard let error = error else {
                self?.getSingleObjectRequest(ref: ref, completion: completion)
                return
            }
            completion(.failure(error))
        }
    }
    
    private func getSingleObjectRequest<T: DatabaseNode>(ref: DatabaseReference, eventType: DataEventType = .value, completion: @escaping (_ result: Result<T?, Error>) -> ()) {
        // Observe a single event of the specified type to retrieve a single object
        ref.observeSingleEvent(of: eventType) { dataSnapshot in
            guard let value = dataSnapshot.value as? [String: Any], let data = try? JSONSerialization.data(withJSONObject: value) else {
                completion(.success(nil))  // poEmpty result if unable to serialize raw data
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
    
    private func getDataRequest(ref: DatabaseReference, completion: @escaping(_ result: Result<DataSnapshot?, Error>) -> ()) {
        ref.getData( completion:  { error, snapshot in
            if let error = error{
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            completion(.success(snapshot))
            
        })
    }
    
    private func getListRequest<T: DatabaseNode>(ref: DatabaseReference, completion: @escaping (_ result: Result<[T]?, Error>) -> ()) {
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
                            var parsedObject = try JSONDecoder().decode(T.self, from: data)
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
    

    private func observeListRequest<T: DatabaseNode>(ref: DatabaseReference, completion: @escaping (_ result: Result<[T]?, Error>) -> ()) -> UInt {
        return ref.observe(.value) { snapshot in
            if let dataSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                var resultArray:[T] = []
                for data in dataSnapshot {
                    let nodeId = data.key // Retrieve the node ID/key
                    if let dataObject = data.value as? [String: Any] {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: dataObject, options: [])
                            var parsedObject = try JSONDecoder().decode(T.self, from: data)
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
    
    private func observeSingleObjectRequest<T: DatabaseNode>(ref: DatabaseReference, eventType: DataEventType, _ type: T.Type, completion: @escaping (_ result: Result<T?, Error>) -> ()) -> UInt {
        return ref.observe(eventType) { dataSnapshot  in
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
    
    private func removeRequest(ref: DatabaseReference, completion: @escaping(_ error: Error?) -> ()) {
        ref.removeValue { error, _ in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    private func removeAllHandles(_ path: DatabaseReference?) {
        var dbRef = DBRef.database
        if let ref = path {
            dbRef = ref
        }
        
        dbRef.removeAllObservers()
    }
    
    private func removeHandles(_ path: DatabaseReference?, _ handles: [UInt]) {
        var dbRef = DBRef.database
        if let ref = path {
            dbRef = ref
        }
        
        for handle in handles {
            dbRef.removeObserver(withHandle: handle)
        }
    }
}
