//
//  Student.swift
//  Students
//
//  Created by Andrew R Madsen on 8/5/18.
//  Copyright © 2018 Lambda Inc. All rights reserved.
//

import Foundation

struct Student: Codable {
    var name: String
    var course: String
    
    var firstName: String {
        String(name.split(separator: " ").first ?? "")
    }
    
    var lastName: String {
        String(name.split(separator: " ").last ?? "")
    }
}
