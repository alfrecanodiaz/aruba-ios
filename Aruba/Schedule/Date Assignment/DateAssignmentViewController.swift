//
//  DateAssignmentViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/9/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

struct Person {
    let gender: Gender
    
    enum Gender: String {
        case Women = "MUJER", Children = "NIÑO", Man = "HOMBRE"
        
        var image: UIImage {
            switch self {
            case .Women:
                return #imageLiteral(resourceName: "women")
            case .Children:
                return #imageLiteral(resourceName: "women")
            case .Man:
                return #imageLiteral(resourceName: "women")
            }
        }
    }
    
    init(gender: Gender) {
        self.gender = gender
    }
}

class DateAssignmentViewController: UIViewController {

    var persons: [Person] = [Person(gender: .Women),Person(gender: .Women), Person(gender: .Man),Person(gender: .Children)]
    var entryAnimationDone: Bool = false
    
    struct Cells {
        static let DateAssignment = "dateAssignmentCell"
    }
    
    struct Segues {
        static let DateAssignment = "DateAssignmentSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
}

extension DateAssignmentViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.DateAssignment, for: indexPath) as! DateAssignmentTableViewCell
        
        cell.configure(person: persons[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: Segues.DateAssignment, sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !entryAnimationDone {
            cell.transform = CGAffineTransform(translationX: 0, y: 40)
            cell.alpha = 0
            UIView.animate(withDuration: 0.3, delay: TimeInterval(0.1*Double(indexPath.row)), usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform.identity
                cell.alpha = 1
            }) { (end) in
                self.entryAnimationDone = true
            }
        }
    }
    
    
}
