//
//  HistoryTableViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/26/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

struct HistoryTableViewCellViewModel {
    let state: String
    let categoryName: String
    let categoryURL: URL?
    let categoryDetails: String
    
    init (appointment: Appointment) {
        state = appointment.currentState.displayName
        let services = appointment.services ?? []
        categoryName = services.reduce(into: "", { (result, service) in
            result +=  service.name + "\n"
        })
        categoryURL =  URL(string: services.first?.imageURL ?? "")
        categoryDetails = "\(appointment.date) | \(appointment.hourStartPretty)"
    }
}

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var categoryDetailsLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView! {
        didSet {
            categoryImageView.layer.cornerRadius = 25
            categoryImageView.clipsToBounds = true
            categoryImageView.contentMode = .scaleAspectFill
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configure(viewModel: HistoryTableViewCellViewModel) {
        stateLabel.text = viewModel.state
        categoryNameLabel.text = viewModel.categoryName
        categoryDetailsLabel.text = viewModel.categoryDetails
        categoryImageView.image = Constants.imagePlaceholder
        guard let url = viewModel.categoryURL else { return }
        categoryImageView.hnk_setImageFromURL(url, placeholder: Constants.imagePlaceholder)
    }
    
}
