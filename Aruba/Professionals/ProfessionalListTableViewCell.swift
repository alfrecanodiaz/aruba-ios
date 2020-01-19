//
//  ProfessionalListTableViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 1/2/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit

class ProfessionalListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rating1: UIImageView!
    @IBOutlet weak var rating2: UIImageView!
    @IBOutlet weak var rating3: UIImageView!
    @IBOutlet weak var rating4: UIImageView!
    @IBOutlet weak var rating5: UIImageView!
    
    
    @IBOutlet weak var professionalImageView: ARoundImage!
    @IBOutlet weak var professionalNameLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var serviceCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(professional: Professional) {
        professionalNameLabel.text = professional.firstName + " " + professional.lastName
        serviceCountLabel.text = "\(professional.servicesCount ?? 0)"
        likeCountLabel.text = "\(professional.likes ?? 0)"
        let averageReviewsAsInt = Int(floor(professional.averageReviews ?? 0))
        if averageReviewsAsInt == 0 {
            rating1.image = #imageLiteral(resourceName: "star")
            rating2.image = #imageLiteral(resourceName: "star")
            rating3.image = #imageLiteral(resourceName: "star")
            rating4.image = #imageLiteral(resourceName: "star")
            rating5.image = #imageLiteral(resourceName: "star")
        } else if averageReviewsAsInt == 1 {
            rating1.image = #imageLiteral(resourceName: "star_filled")
            rating2.image = #imageLiteral(resourceName: "star")
            rating3.image = #imageLiteral(resourceName: "star")
            rating4.image = #imageLiteral(resourceName: "star")
            rating5.image = #imageLiteral(resourceName: "star")
        } else if averageReviewsAsInt == 2 {
            rating1.image = #imageLiteral(resourceName: "star_filled")
            rating2.image = #imageLiteral(resourceName: "star_filled")
            rating3.image = #imageLiteral(resourceName: "star")
            rating4.image = #imageLiteral(resourceName: "star")
            rating5.image = #imageLiteral(resourceName: "star")
        } else if averageReviewsAsInt == 3 {
            rating1.image = #imageLiteral(resourceName: "star_filled")
            rating2.image = #imageLiteral(resourceName: "star_filled")
            rating3.image = #imageLiteral(resourceName: "star_filled")
            rating4.image = #imageLiteral(resourceName: "star")
            rating5.image = #imageLiteral(resourceName: "star")
        } else if averageReviewsAsInt == 4 {
            rating1.image = #imageLiteral(resourceName: "star_filled")
            rating2.image = #imageLiteral(resourceName: "star_filled")
            rating3.image = #imageLiteral(resourceName: "star_filled")
            rating4.image = #imageLiteral(resourceName: "star_filled")
            rating5.image = #imageLiteral(resourceName: "star")
        } else if averageReviewsAsInt == 5 {
            rating1.image = #imageLiteral(resourceName: "star_filled")
            rating2.image = #imageLiteral(resourceName: "star_filled")
            rating3.image = #imageLiteral(resourceName: "star_filled")
            rating4.image = #imageLiteral(resourceName: "star_filled")
            rating5.image = #imageLiteral(resourceName: "star_filled")
        }
        
        guard let url = URL(string: professional.avatarURL ?? "") else { return }
        professionalImageView.hnk_setImageFromURL(url, placeholder: Constants.userPlaceholder)
    }
}
