//
//  StudentController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import Foundation

enum TrackType: Int {
    case none
    case iOS
    case Web
    case UX
}

enum SortOption: Int {
    case firstName
    case lastName
}

class StudentController {
    // MARK: - Private Properties
    private var students: [Student] = []
    
    private var persistentFileURL: URL? {
        guard let filePath = Bundle.main.path(forResource: "students", ofType: "json") else { return nil }
        return URL(fileURLWithPath: filePath)
    }
    
    //MARK: - Public Functions
    func loadFromPersistentStore(completion: @escaping ([Student]?, Error?) -> Void) {
        let bgQueue = DispatchQueue(label: "studentQueue", attributes: .concurrent)
        bgQueue.async {
            guard let url = self.persistentFileURL else { return }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.students = try decoder.decode([Student].self, from: data)
                completion(self.students, nil)
            } catch {
                print("Error loading student data: \(error)")
                completion(nil, error)
            }
        }
    }
    
    func filter(with trackType: TrackType, sortedBy sorter: SortOption) -> [Student] {
        var updatedStudents: [Student]
        
        switch trackType {
        case .iOS:
            updatedStudents = students.filter({ student -> Bool in
                return student.course == "iOS"
            })
        case .Web:
            updatedStudents = students.filter({ $0.course == "Web" })
        case .UX:
            updatedStudents = students.filter { $0.course == "UX" }
        case .none:
            updatedStudents = students
        }
        
        switch sorter {
        case .firstName:
            updatedStudents = updatedStudents.sorted(by: { studentA, StudentB -> Bool in
                return studentA.firstName < StudentB.firstName
            })
        case .lastName:
            updatedStudents = updatedStudents.sorted { $0.lastName < $1.lastName }
        }
        
        return updatedStudents
    }
}
