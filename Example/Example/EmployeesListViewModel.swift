//
//  EmployeesListViewModel.swift
//  Example
//
//  Created by Maaz Rafique on 05/07/2023.
//

import Foundation
import FirebaseServicesManager

class EmployeesListViewModel {
    var employeesList: [Employee] = []
    var dbEmployeesList: [DBEmployee] = []

    func fetchAllEmployees(completion: @escaping(_ error: Error?) -> ()) {
        if AppController.shared.operationType == .firestore {
            switch AppController.shared.reactiveType {
            case .observable:
                observeFirestoreEmployee { error in
                    completion(error)
                }
            case .nonObservable:
                getFirestoreEmployees { error in
                    completion(error)
                }
            }
        } else {
            switch AppController.shared.reactiveType {
            case .observable:
                observeDatabaseEmployees { error in
                    completion(error)
                }
            case .nonObservable:
                getDatabaseEmployees { error in
                    completion(error)
                }
            }
        }
    }
    
    private func getFirestoreEmployees(completion: @escaping(_ error: Error?) -> ()) {
        let query = FSQuery.firestore.collection("employees")
        FirebaseServices.manager.firestore.getList(Employee.self, firestore: query) { result in
            switch result {
            case .success(let employees):
                self.employeesList = employees
                completion(nil)
            case .failure(let error):
                completion(error)
                
            }
        }
    }
    private func observeFirestoreEmployee(completion: @escaping(_ error: Error?) -> ()) {
        let query = FSQuery.firestore.collection("employees")
        FirebaseServices.manager.firestore.observeDocuments(query: query, Employee.self) { result in
            switch result {
            case .success(let employees):
                self.employeesList = employees
                completion(nil)
            case .failure(let error):
                completion(error)
                
            }
        }
    }
    private func getDatabaseEmployees(completion: @escaping(_ error: Error?) -> ()) {
        let ref = DBRef.database.child("employees")
        FirebaseServices.manager.database.getList(ref: ref) { (result: Result<[DBEmployee]?, Error>)  in
            switch result {
            case .success(let employees):
                self.dbEmployeesList = employees ?? []
                completion(nil)
            case .failure(let error):
                completion(error)
                
            }
        }
    }
    private func observeDatabaseEmployees(completion: @escaping(_ error: Error?) -> ()) {
        let ref = DBRef.database.child("employees")
        let _ = FirebaseServices.manager.database.observeList(ref: ref) { (result:  Result<[DBEmployee]?, Error>) in
            switch result {
            case .success(let employees):
                self.dbEmployeesList = employees ?? []
                completion(nil)
            case .failure(let error):
                completion(error)
                
            }
        }    }
}
