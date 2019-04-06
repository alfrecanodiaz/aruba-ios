//
//  PopupTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

protocol PopupDelegate: class {
    func popupDidSelectAccept(selectedIndex: Int)
}

class PopupTableViewController: APopoverTableViewController {

    var titleString: String!
    var options: [GenericDataCellViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    weak var delegate: PopupDelegate?
    
    private let headerHeight: CGFloat = 50
    private let footerHeight: CGFloat = 70
    
    struct Cells {
        static let GenericData = "GenericDataCellTableViewCell"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: Cells.GenericData, bundle: nil), forCellReuseIdentifier: Cells.GenericData)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.GenericData, for: indexPath) as? GenericDataCellTableViewCell else { return UITableViewCell() }
        cell.viewModel = options[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerHeight))
        let lbl = UILabel()
    
        view.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        lbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        lbl.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .center
        lbl.text = titleString
        return view
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cancelBtn = AButton()
        cancelBtn.titleLabel?.textColor = .white
        cancelBtn.setTitle("CANCELAR", for: .normal)
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerHeight)
        let stackView = UIStackView(frame: frame)
        stackView.addArrangedSubview(cancelBtn)
        cancelBtn.backgroundColor = Colors.ButtonGreen
        stackView.alignment = .center
        
        return stackView
    }
  
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.popupDidSelectAccept(selectedIndex: indexPath.row)
    }
}
