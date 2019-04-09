//
//  HomeTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

struct Category {
    let image: UIImage?
    let title: String
    let color: UIColor
    
    init(imageName: String, title: String, color: UIColor) {
        image = UIImage(named: imageName)
        self.title = title
        self.color = color
    }
}

class HomeTableViewController: BaseTableViewController {
    
    var entryAnimationDone: Bool = false
    var popup: PopupTableViewController!
    struct Cells {
        static let Category = "homeCategoryCell"
    }
    
    struct Segues {
        static let ScheduleService = "scheduleServiceSegue"
    }
    
    var categories:[Category] = [] {
        didSet {
            tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        categories = [Category(imageName: "peluqueria_blanco", title: "PELUQUERIA", color: Colors.Peluqueria), Category(imageName: "manicura_blanco", title: "MANICURA/PEDICURA", color: Colors.Manicura), Category(imageName: "estetica_blanco", title: "ESTETICA", color: Colors.Estetica), Category(imageName: "masajes_blanco", title: "MASAJES", color: Colors.Masajes),Category(imageName: "nutricion_blanco", title: "NUTRICIÓN", color: Colors.Nutricion), Category(imageName: "barberia_blanco", title: "BARBERIA", color: Colors.Peluqueria)]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.bounds.height - (UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)))/6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.Category, for: indexPath) as? HomeCategoryTableViewCell else { return UITableViewCell() }
        cell.configure(category: categories[indexPath.row])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        popup = showPopup(title: "Dirección del servicio", options: [GenericDataCellViewModel(address: Address()),GenericDataCellViewModel(address: Address())], delegate: self)
    }
    
    override func popupDidSelectAccept(selectedIndex: Int) {
        super.popupDidSelectAccept(selectedIndex: selectedIndex)
        popup.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: Segues.ScheduleService, sender: self)
        print("Selected index: \(selectedIndex)")
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !entryAnimationDone {
            cell.transform = CGAffineTransform(translationX: 0, y: -40)
            cell.alpha = 0
            UIView.animate(withDuration: 0.3, delay: TimeInterval(0.1*Double(indexPath.row)), usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform.identity
                cell.alpha = 1
            }) { (end) in
                self.entryAnimationDone = true
            }
        }
//        guard let cell = cell as? HomeCategoryTableViewCell else { return }
//        cell.backgroundImageView.layer.cornerRadius = cell.backgroundImageView.bounds.width/2
    }


}
