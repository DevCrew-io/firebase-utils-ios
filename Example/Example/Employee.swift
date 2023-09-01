//
//  Employee.swift
//  Example
//
//  Copyright © 2023 DevCrew I/O.
//

import Foundation
import FirebaseServicesManager


struct FSEmployee: FirestoreDocument {
    var docChangeType: FirebaseServicesManager.DocumentChangeType?
    var docId: String?
    var name: String
    var picUrl: String?
    var picName: String?
    var jobTitle: String
    var department: String
    var manger: String?
    var about: String?
    var address: String?
    var email: String?
    var phone: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.docId = try container.decodeIfPresent(String.self, forKey: .docId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.picUrl = try container.decodeIfPresent(String.self, forKey: .picUrl)
        self.picName = try container.decodeIfPresent(String.self, forKey: .picName)
        self.jobTitle = try container.decodeIfPresent(String.self, forKey: .jobTitle) ?? ""
        self.department = try container.decodeIfPresent(String.self, forKey: .department) ?? ""
        self.manger = try container.decodeIfPresent(String.self, forKey: .manger)
        self.about = try container.decodeIfPresent(String.self, forKey: .about)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
    }
    
    init(name: String = "", jobTitle: String = "", department: String = "") {
        self.name = name
        self.jobTitle = jobTitle
        self.department = department
    }
    
}

struct DBEmployee: DatabaseNode {
    var nodeId: String?
    var name: String
    var picUrl: String?
    var picName: String?
    var jobTitle: String
    var department: String
    var manger: String?
    var about: String?
    var address: String?
    var email: String?
    var phone: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.nodeId = try container.decodeIfPresent(String.self, forKey: .nodeId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.picUrl = try container.decodeIfPresent(String.self, forKey: .picUrl)
        self.picName = try container.decodeIfPresent(String.self, forKey: .picName)
        self.jobTitle = try container.decodeIfPresent(String.self, forKey: .jobTitle) ?? ""
        self.department = try container.decodeIfPresent(String.self, forKey: .department) ?? ""
        self.manger = try container.decodeIfPresent(String.self, forKey: .manger)
        self.about = try container.decodeIfPresent(String.self, forKey: .about)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
    }
    
    init(name: String = "", jobTitle: String = "", department: String = "") {
        self.name = name
        self.jobTitle = jobTitle
        self.department = department
    }
    
}
