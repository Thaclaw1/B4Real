//
//  Models.swift
//  B4real
//
//  Created by thaclaw on 11/15/24.
//





import ParseSwift
import Foundation


struct User: ParseUser {
    var emailVerified: Bool?
    
    var authData: [String : [String : String]?]?
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    var username: String?
    var password: String?
    var email: String?
    var phone: String?
}


struct Post: ParseObject {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    var image: ParseFile?
    var caption: String?
    var user: User?
}

