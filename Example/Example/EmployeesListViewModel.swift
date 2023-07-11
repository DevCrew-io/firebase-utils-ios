//
//  EmployeesListViewModel.swift
//  Example
//
//  Created by Maaz Rafique on 05/07/2023.
//

import Foundation
import FirebaseServicesManager

class EmployeesListViewModel: ObservableObject {
    @Published var employeesList: [Employee] = []
    func fetchAllEmployees(completion: @escaping(_ error: Error?) -> ()) {
        let query = FSMQuery.firestore.collection("employees")
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
}
