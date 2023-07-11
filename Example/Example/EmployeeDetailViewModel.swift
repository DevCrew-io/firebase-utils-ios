//
//  EmployeeDetailViewModel.swift
//  Example
//
//  Created by Maaz Rafique on 06/07/2023.
//

import Foundation
import FirebaseServicesManager

class EmployeeDetailViewModel {
    func fetchEmployeeDetails(empId: String, completion: @escaping(_ result: Result<Employee?, Error>) -> ()) {
        FirebaseServices.manager.firestore.observeDocument(with: empId, from: "employees", Employee.self) { result in
            completion(result)
        }
    }
}
