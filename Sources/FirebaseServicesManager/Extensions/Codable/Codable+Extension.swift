//
//  Codable+Extension.swift
//
//
//  Created by Maaz Rafique on 23/06/2023.
//

import Foundation

extension Encodable {
    /// Converts the encodable object to a dictionary representation.
    ///
    /// - Returns: A dictionary representation of the encodable object, where the keys are strings and the values are of type `Any`.
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
        return json
    }
    
    /// Converts the encodable object to data.
    ///
    /// - Returns: Data representation of the encodable object.
    func toData() -> Data? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return data
    }
}
