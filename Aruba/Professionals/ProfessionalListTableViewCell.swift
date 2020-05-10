//
//  ProfessionalListTableViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 1/2/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit
import Lottie

class ProfessionalListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rating1: UIImageView!
    @IBOutlet weak var rating2: UIImageView!
    @IBOutlet weak var rating3: UIImageView!
    @IBOutlet weak var rating4: UIImageView!
    @IBOutlet weak var rating5: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            likeButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var professionalImageView: ARoundImage!
    @IBOutlet weak var professionalNameLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var serviceCountLabel: UILabel!
    
    var professionalId: Int!
    var isProfessionalLiked: Bool = false
    weak var delegate: ProfessionalLikedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(professional: Professional) {
        professional.isLikedByMe ? self.likeButton.setImage(#imageLiteral(resourceName: "heart_filled_big"), for: .normal) : self.likeButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        isProfessionalLiked = professional.isLikedByMe
        professionalId = professional.id
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
        professionalImageView.kf.setImage(with: url, placeholder: GlobalConstants.userPlaceholder)
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        ALoader.show()
        let params = ["professional_id": professionalId]
        HTTPClient.shared.request(method: .POST, path: .likeProfessional, data: params as [String : Any]) { (response: DefaultResponseAsString?, error) in
            ALoader.hide()
            self.isProfessionalLiked.toggle()
            self.delegate?.didLikedProfessional(professionalId: self.professionalId, liked: self.isProfessionalLiked)
            self.isProfessionalLiked ? self.likedHandler() : self.unlikeHandler()
        }
    }
    
    private func likedHandler() {
        showLottieSuccess()
        self.likeButton.setImage(#imageLiteral(resourceName: "heart_filled_big"), for: .normal)
        likeCountLabel.text = "\((Int(likeCountLabel.text ?? "0") ?? 0) + 1)"
    }
    
    private func unlikeHandler() {
        self.likeButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        likeCountLabel.text = "\((Int(likeCountLabel.text ?? "0") ?? 0) - 1)"
    }
    
    private func showLottieSuccess() {
        let lottieView = AnimationView(name: "like_aruba")
        lottieView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        lottieView.contentMode = .scaleAspectFit
        UIApplication.shared.keyWindow!.addSubview(lottieView)
        lottieView.center = UIApplication.shared.keyWindow!.center
        lottieView.play { (_) in
            lottieView.removeFromSuperview()
        }
    }
}
