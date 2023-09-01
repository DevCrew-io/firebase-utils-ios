//
//  FirestoreDocument.swift
//
//
//  Copyright © 2023 DevCrew I/O.
//

import Foundation

public enum DocumentChangeType: Codable {
case added, modified, removed
}

/// Protocol for representing a document in Firestore.
public protocol FirestoreDocument: Codable {
    /// The document ID associated with the Firestore document.
    var docId: String? { get set }
    var docChangeType: DocumentChangeType? {get set}
}

extension FirestoreDocument {
    /// Default implementation of the `docId` property for conforming types.
    var docId: String? {
        get { return nil }  // Returns nil by default
        set {}  // Empty setter to satisfy the protocol requirement
    }
    
    var docChangeType: DocumentChangeType? {
        get {return nil}
        set {}
    }
}

