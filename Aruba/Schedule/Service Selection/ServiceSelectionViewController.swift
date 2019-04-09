//
//  ServiceSelectionViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/8/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class ServiceSelectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var serviceTypeSegmentedControl: UISegmentedControl!
    
    struct Cells {
        static let ServiceSelection = "ServiceSelectionCell"
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ServiceSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return serviceOptions.count
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
