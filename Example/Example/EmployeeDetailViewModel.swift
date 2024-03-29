//
//  EmployeeDetailViewModel.swift
//  Example
//
//  Copyright © 2023 DevCrew I/O.
//

import Foundation
import FirebaseServicesManager

class EmployeeDetailViewModel {
    func fetchFSEmployeeDetails(id: String, completion: @escaping(_ result: Result<FSEmployee?, Error>) -> ()) {
        let _ = FirebaseServices.manager.firestore.observeDocument(with: id, from: "employees", FSEmployee.self) { result in
            completion(result)
        }
    }
    
    func fetchDBEmployeeDetails(id: String, completion: @escaping(_ result: Result<DBEmployee?, Error>) -> ()) {
        let ref = DBRef.database.child("employees").child(id)
        _ = FirebaseServices.manager.database.observeSingleObject(ref: ref) { (result: Result<DBEmployee?, Error>) in
            completion(result)
        }
    }
}
