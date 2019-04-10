//
//  ServiceSelectionViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/8/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class ServiceSelectionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var serviceTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var totalLbl: UILabel!
        
    struct Cells {
        static let ServiceSelection = "ServiceSelectionCell"
    }
    
    struct Segues {
        static let DateAssignments = "pushDateAssignmentSegue"
        static let Popup = "presentPopup"
    }
    
    struct ServiceOption {
        let name: String
    }
    
    var serviceOptions: [ServiceOption] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        tableView.register(UINib(nibName: "ServiceSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.ServiceSelection)
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.DateAssignments {
            
        }
        if segue.identifier == Segues.Popup {
            
        }
    }
    
    @IBAction func unwindToServiceSelection(segue: UIStoryboardSegue) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performSegue(withIdentifier: Segues.DateAssignments, sender: self)
        }
    }

}

extension ServiceSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return serviceOptions.count
        // TODO: Replace with real data
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ServiceSelection, for: indexPath) as? ServiceSelectionTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    
    
}
