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
    func popupDidDissmiss()
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
    private let footerHeight: CGFloat = 40

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
        cell.delegate = self
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
        lbl.font = AFont.with(size: 14, weight: .regular)
        return view
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: footerHeight))
        view.backgroundColor = Colors.ButtonGreen
        let lbl = UILabel(frame: view.frame)
        lbl.textColor = .white
        lbl.text = "CANCELAR"
        lbl.font = AFont.with(size: 18, weight: .regular)
        lbl.textAlignment = .center
        view.addSubview(lbl)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPopup(sender:)))
        view.addGestureRecognizer(tap)
        return view
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

    // MARK: Methods

    @objc private func dismissPopup(sender: UITapGestureRecognizer) {
        delegate?.popupDidDissmiss()
        dismiss(animated: true, completion: nil)
    }

}

extension PopupTableViewController: GenericDataCellTableViewCellProtocol {

    func didSelectDelete(for index: Int) {

    }
}
