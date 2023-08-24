//
//  AppController.swift
//  Example
//
//  Copyright © 2023 DevCrew I/O.
//

import Foundation

class AppController {
    static let shared = AppController()
    private init() {
        
    }
    var operationType: OperationType = .firestore
    var reactiveType: ReactiveType = .nonObservable
}
