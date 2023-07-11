//
//  SetEmployeeViewModel.swift
//  Example
//
//  Created by Maaz Rafique on 05/07/2023.
//

import Foundation
import FirebaseServicesManager

class SetEmployeeViewModel {
    func add(employee: Employee, completion: @escaping(_ result: Result<Employee?, Error>) -> ()) {
        FirebaseServices.manager.firestore.add(documentAt: "employees", dataObject: employee) { result in
            completion(result)
        }
    }
    
    func update(empId: String, employee: Employee, completion: @escaping(_ result: Result<Employee?, Error>) -> ()) {
        FirebaseServices.manager.firestore.update(with: empId, documentIn: "employees", dataObject: employee) { result in
            completion(result)
            
        }
    }
    
    func uploadProfileImage(imageData: Data, name: String, folder: String, completion: @escaping(_ result: Result<(String?, String?), Error>) -> ()) {
        FirebaseServices.manager.storage.upload(file: imageData, with: name, in: folder) { result in
            completion(result)
        }
    }
    
    func updateProfileImage(imageData: Data, name: String, folder: String, completion: @escaping(_ result: Result<(String?, String?), Error>) -> ()) {
        FirebaseServices.manager.storage.update(file: imageData, with: name, in: folder) { result in
            completion(result)
        }
    }
    
    func deleteProfileImage(url: String, completion: @escaping(_ result: Result<Bool?, Error>) -> ()) {
        FirebaseServices.manager.storage.delete(file: url, colletion: "images") { result in
            completion(result)
        }
    }
}
