//
//  Enums.swift
//  Example
//
//  Created by Maaz Rafique on 12/07/2023.
//

import Foundation

enum OperationType {
    case firestore
    case database
}

enum ReactiveType {
    case observable
    case nonObservable
}

enum TappedButton: Int {
    case database = 0
    case reactiveDatabase = 1
    case firestore = 2
    case reactiveFirestore = 3
}
