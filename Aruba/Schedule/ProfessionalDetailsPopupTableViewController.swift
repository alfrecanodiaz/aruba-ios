//
//  ProfessionalDetailsPopupTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/14/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

protocol ProfessionalDetailsPopupTableViewControllerDelegate: class {
    func didSelectProfessional(professional: Professional)
    func didCancelPopupForProfessional(professional: Professional)
}

class ProfessionalDetailsPopupTableViewController: APopoverTableViewController {
    
    @IBOutlet weak var likedImageView: UIImageView!
    @IBOutlet weak var professionalNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var appointmentCountLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    @IBOutlet weak var dateDetailsView: UIView! {
        didSet {
             dateDetailsView.layer.borderColor = UIColor.lightGray.cgColor
             dateDetailsView.layer.borderWidth = 1
             dateDetailsView.layer.cornerRadius = 8
             dateDetailsView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
         }
    }

    @IBOutlet weak var userAvatarImageView: UIImageView! {
        didSet {
            userAvatarImageView.layer.cornerRadius = 40
            userAvatarImageView.clipsToBounds = true
        }
    }
    
    var professional: Professional!
    var date: String!
    var time: String!
    
    weak var delegate: ProfessionalDetailsPopupTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let filled = #imageLiteral(resourceName: "heart_filled_big")
        let unfilled = #imageLiteral(resourceName: "heart")
        likedImageView.image = professional.isLikedByMe ? filled : unfilled
        dateLabel.text = date
        timeLabel.text = time
        likesLabel.text = "\(professional.likes ?? 0)"
        appointmentCountLabel.text = "\(professional.servicesCount ?? 0)"
        commentsLabel.text = "\(professional.reviewsWithCommentsCount ?? 0)"
        averageLabel.text = "\(Int(professional.averageReviews ?? 0))"
        professionalNameLabel.text = professional.firstName + " " + professional.lastName
        guard let url = URL(string: professional.avatarURL ?? "") else {
            return
        }
        userAvatarImageView.hnk_setImageFromURL(url, placeholder: GlobalConstants.userPlaceholder)
    }
    
    @IBAction func selectProfessionalAction(_ sender: AButton) {
        dismiss(animated: true) {
            self.delegate?.didCancelPopupForProfessional(professional: self.professional)
        }
    }
}
