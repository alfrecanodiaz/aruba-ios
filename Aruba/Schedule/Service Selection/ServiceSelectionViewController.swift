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
    @IBOutlet weak var continueBtn: AButton!

    struct Cells {
        static let ServiceSelection = "ServiceSelectionCell"
    }

    struct Segues {
        static let DateAssignments = "pushDateAssignmentSegue"
        static let Popup = "presentPopup"
        static let ProductPopup = "showProductPopover"
    }

    var products: [Product] = [Product(name: "Shampoo", description: "Una descripcion larga de un producto", image: #imageLiteral(resourceName: "profile"), price: 10000), Product(name: "Maquillaje", description: "Una descripcion larga de un producto", image: #imageLiteral(resourceName: "profile"), price: 23000), Product(name: "Shampoo", description: "Una descripcion larga de un producto", image: #imageLiteral(resourceName: "profile"), price: 10000), Product(name: "Shampoo", description: "Una descripcion larga de un producto", image: #imageLiteral(resourceName: "profile"), price: 10000), Product(name: "Shampoo", description: "Una descripcion larga de un producto", image: #imageLiteral(resourceName: "profile"), price: 10000), Product(name: "Shampoo", description: "Una descripcion larga de un producto", image: #imageLiteral(resourceName: "profile"), price: 10000)]

    private var selectedIndexPaths: [IndexPath] = []
    private var currentPerson: Person!
    private var remainingPersons: [Person] = []
    var persons: [Person]!

    var schedulePersons: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        tableView.register(UINib(nibName: "ServiceSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.ServiceSelection)
        tableView.dataSource = self
        tableView.delegate = self
        remainingPersons = persons
        currentPerson = remainingPersons.remove(at: 0)
        setupView(for: currentPerson)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.DateAssignments {
            let dvc = segue.destination as! DateAssignmentViewController
            dvc.scheduleData = ScheduleData(persons: schedulePersons)

        }
        if segue.identifier == Segues.Popup {

        }
    }

    @IBAction func unwindToServiceSelection(segue: UIStoryboardSegue) {
        currentPerson.scheduleProducts = selectedIndexPaths.map({products[$0.row]})
        schedulePersons.append(currentPerson)
        if remainingPersons.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: Segues.DateAssignments, sender: self)
            }
        } else {
            currentPerson = remainingPersons.remove(at: 0)
            setupView(for: currentPerson)
        }

    }

    private func setupView(for person: Person) {
        imageView.image = person.gender.image
        genderLbl.text = person.gender.rawValue
        let currentGender = person.gender
        let sameGenderCount = persons.filter({$0.gender == currentGender}).count
        let remainingSameGenderCount = remainingPersons.filter({$0.gender == currentGender }).count
        let currentCount = (remainingSameGenderCount - sameGenderCount)*(-1)
        selectedIndexPaths = []
        tableView.reloadData()
        countLbl.text = "\(currentCount)"
        continueBtn.setEnabled(false)
        calculateTotal()
    }

    public func showProductDescriptionPopup(product: Product) {
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "ProductDescriptionPopupTableViewControllerID") as! ProductDescriptionPopupTableViewController
        popup.product = product
        popup.modalPresentationStyle = .popover
        let popover = popup.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = view
        popover?.sourceRect = view.bounds
        popover?.permittedArrowDirections = .init(rawValue: 0)

        popup.delegate = self
        present(popup, animated: true, completion: nil)
    }

}

extension ServiceSelectionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ServiceSelection, for: indexPath) as? ServiceSelectionTableViewCell else { return UITableViewCell() }

        cell.configure(product: products[indexPath.row], isSelected: selectedIndexPaths.contains(indexPath), indexPath: indexPath)

        cell.delegate = self
        return cell
    }

    private func calculateTotal() {
        var total: Double = 0

        for indexPath in selectedIndexPaths {
            total = products[indexPath.row].price + total
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_PY")
        totalLbl.text = formatter.string(from: NSNumber(value: total))
    }

}

extension ServiceSelectionViewController: ServiceSelectionTableViewCellDelegate {
    func didSelectViewProductDescription(at indexPath: IndexPath) {
        showProductDescriptionPopup(product: products[indexPath.row])
    }

    func didSelectProduct(selected: Bool, at indexPath: IndexPath) {
        if selected {
            selectedIndexPaths.append(indexPath)
        } else {
            guard let index =  selectedIndexPaths.firstIndex(of: indexPath) else { return }
            selectedIndexPaths.remove(at: index)
        }
        continueBtn.setEnabled(!selectedIndexPaths.isEmpty)
        calculateTotal()
    }
}

extension ServiceSelectionViewController: ProductPopupDelegate {

    func didSelectProduct(product: Product) {
        //TODO, create real comparison
        guard let index = products.firstIndex(where: {$0.name == product.name}) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        if !selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.append(indexPath)
        }
        tableView.reloadData()
    }

}

extension ServiceSelectionViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
