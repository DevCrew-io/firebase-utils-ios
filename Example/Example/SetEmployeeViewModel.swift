//
//  SetEmployeeViewModel.swift
//  Example
//
//  Copyright © 2023 DevCrew I/O.
//

import Foundation
import FirebaseServicesManager

class SetEmployeeViewModel {
    func add(fsEmployee: FSEmployee, completion: @escaping(_ result: Result<FSEmployee?, Error>) -> ()) {
        FirebaseServices.manager.firestore.add(documentAt: "employees", dataObject: fsEmployee) { result in
            completion(result)
        }
    }
    
    func add(dbEmployee: DBEmployee, completion: @escaping(_ result: Result<DBEmployee?, Error>) -> ()) {
        let ref = DBRef.database.child("employees").childByAutoId()
        FirebaseServices.manager.database.add(ref: ref, dataObject: dbEmployee) { result in
            completion(result)
        }
    }

        

// // Create New Record
//        let model = DBEmployee(name: "Najam", jobTitle: "Sr, Software Engineer", department: "Mobile Development")
//        FirebaseServices.manager.database.add(path: DBRef.database.child("Users"), dataObject: model) { (result) in
//
//            switch result {
//            case .success(let response):
//                print(response)
//            case .failure(let error):
//                print(error)
//            }
//
//        }
        
        
        // // Update Record
//        var model = DBEmployee(name: "Najam", jobTitle: "Sr, Software Engineer", department: "Mobile Development")
//        model.nodeId = "ABVCGGSUD"
//        FirebaseServices.manager.database.update(ref: DBRef.database.child("-N_YGZsLg_dAZFYTLyDs"), dataObject: model) { result in
//
//            switch result {
//            case .success(let response):
//                print(response)
//            case .failure(let error):
//                print(error)
//            }
//
//        }
        
        
        // // Fetch List
//        FirebaseServices.manager.database.getList(ref: DBRef.database) { (result: Result<[DBEmployee]?, Error>) in
//
//            switch result {
//            case .success(let response):
//                print(response)
//            case .failure(let error):
//                print(error)
//            }
//
//        }
        
    
    func update(empId: String, fsEmployee: FSEmployee, completion: @escaping(_ result: Result<FSEmployee?, Error>) -> ()) {
        FirebaseServices.manager.firestore.update(with: empId, documentIn: "employees", dataObject: fsEmployee) { result in
            completion(result)
            
        }
    }
    
    func update(id: String, dbEmployee: DBEmployee, completion: @escaping(_ result: Result<DBEmployee?, Error>) -> ()) {
        let dbRef = DBRef.database.child("employees").child(id)
        FirebaseServices.manager.database.update(ref: dbRef, dataObject: dbEmployee) { result in
            completion(result)
        }
    }
    
    func uploadProfileImage(imageData: Data, name: String, folder: String, completion: @escaping(_ result: Result<(String?, String?), Error>) -> ()) {
        let _ = FirebaseServices.manager.storage.upload(file: imageData, with: name, in: folder, metaData: nil) { progress in
            print(progress)
        } completion: { result in
            completion(result)
        }
    }
    
    func updateProfileImage(imageData: Data, name: String, folder: String, completion: @escaping(_ result: Result<(String?, String?), Error>) -> ()) {
        let _ = FirebaseServices.manager.storage.update(file: imageData, with: name, in: folder) { progress in
            print(progress)
        } completion: { result in
            completion(result)
        }

    }
    
    func deleteProfileImage(url: String, completion: @escaping(_ result: Result<Bool?, Error>) -> ()) {
        FirebaseServices.manager.storage.delete(file: url, colletion: "images") { result in
            completion(result)
        }
    }
}
