//
//  AppController.swift
//  Example
//
//  Created by Maaz Rafique on 12/07/2023.
//

import Foundation

class AppController {
    static let shared = AppController()
    private init() {
        
    }
    var operationType: OperationType = .firestore
    var reactiveType: ReactiveType = .nonObservable
}
