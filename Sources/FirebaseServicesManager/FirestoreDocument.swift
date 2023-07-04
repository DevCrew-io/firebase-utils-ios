//
//  FirestoreDocument.swift
//
//
//  Created by Maaz Rafique on 03/05/2023.
//

import Foundation

/// Protocol for representing a document in Firestore.
public protocol FirestoreDocument: Codable {
    /// The document ID associated with the Firestore document.
    var docId: String? { get set }
}

extension FirestoreDocument {
    /// Default implementation of the `docId` property for conforming types.
    var docId: String? {
        get { return nil }  // Returns nil by default
        set {}  // Empty setter to satisfy the protocol requirement
    }
}
