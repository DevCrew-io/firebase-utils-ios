//
//  File.swift
//  
//
//  Copyright © 2023 DevCrew I/O.
//

import Foundation

public protocol DatabaseNode: Codable {
    /// The document ID associated with the Database node.
    var nodeId: String? { get set }
}

extension DatabaseNode {
    /// Default implementation of the `nodeId` property for conforming types.
    var nodeId: String? {
        get { return nil }  // Returns nil by default
        set {}  // Empty setter to satisfy the protocol requirement
    }
}
