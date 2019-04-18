//
//  ProductDescriptionPopupTableViewController.swift
//  Aruba
//
//  Created by javier on 4/18/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

struct Product {
    let name: String
    let description: String
    let image: UIImage
    let price: Double
}

protocol ProductPopupDelegate: class {
    func didSelectProduct(product: Product)
}

class ProductDescriptionPopupTableViewController: BaseTableViewController {
    
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    
    weak var delegate: ProductPopupDelegate?
    
    var product: Product!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }

    private func setupView() {
        //tableView Setup
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        //Product Setup
        productNameLbl.text = product.name
        productImageView.image = product.image
        productDescriptionTextView.text = product.description
    }

    @IBAction func selectAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.didSelectProduct(product: self.product)
        }
    }
}
