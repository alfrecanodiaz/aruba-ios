//
//  ProductDescriptionPopupTableViewController.swift
//  Aruba
//
//  Created by javier on 4/18/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

protocol ProductPopupDelegate: class {
    func didSelectService(service: Service, segmentedIndex: Int, indexPath: IndexPath)
}

class ProductDescriptionPopupTableViewController: APopoverTableViewController {

    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDescriptionTextView: UITextView!

    weak var delegate: ProductPopupDelegate?

    var service: Service!
    var segmentedIndex: Int!
    var indexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }

    private func setupView() {
        //tableView Setup
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        //Service Setup
        productNameLbl.text = service.displayName
        
        let htmlData = NSString(string: service.description).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        
        productDescriptionTextView.attributedText = attributedString
        guard let url = URL(string: service.imageURL) else {
            return
        }
        productImageView.hnk_setImageFromURL(url, placeholder: Constants.imagePlaceholder)
    }

    @IBAction func selectAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.didSelectService(service: self.service, segmentedIndex: self.segmentedIndex, indexPath: self.indexPath)
        }
    }
}
