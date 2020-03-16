//
//  MainViewController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var sortSelector: UISegmentedControl!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private let studentController = StudentController()
    
    private var filteredAndSortedStudents: [Student] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Properties

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        studentController.loadFromPersistentStore { students, error in
            guard error == nil else {
                print("Error loading students: \(error!)")
                return
            }
            guard let students = students else {
                print("Error loading students: Student array nil")
                return
            }
            self.filteredAndSortedStudents = students
        }
    }
    
    // MARK: - Action Handlers
    
    @IBAction func sort(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    @IBAction func filter(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    // MARK: - Private
    
    private func updateDataSource() {
        let filter = TrackType(rawValue: filterSelector.selectedSegmentIndex) ?? .none
        let sort  = SortOption(rawValue: sortSelector.selectedSegmentIndex) ?? .firstName
        
        filteredAndSortedStudents = studentController.filter(with: filter, sortedBy: sort)
    }
}

extension StudentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAndSortedStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        let student = filteredAndSortedStudents[indexPath.row]
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = student.course
        return cell
    }
}
