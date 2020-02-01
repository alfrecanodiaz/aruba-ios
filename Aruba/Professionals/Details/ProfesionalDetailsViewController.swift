//
//  ProfesionalDetailsViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 2/1/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit
import Lottie

protocol ProfessionalLikedDelegate: NSObject {
    func didLikedProfessional(professionalId: Int, liked: Bool)
}

class ProfesionalDetailsViewController: UIViewController {
    // Inject in prepare for segue
    var professional: Professional!
    var comments: [RatingData]  = []
    
    @IBOutlet weak var professionalImageView: ARoundImage!
    @IBOutlet weak var professionalNameLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var servicesCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var reviewAverageLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView! {
        didSet {
            commentsTableView.delegate = self
            commentsTableView.dataSource = self
            commentsTableView.tableFooterView = UIView()
            commentsTableView.rowHeight = UITableView.automaticDimension
            commentsTableView.estimatedRowHeight = 100
            commentsTableView.backgroundView = spinner
            commentsTableView.register(UINib(nibName: "HistoryServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryServiceCell")
        }
    }
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            likeButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    var liked: Bool = false
    weak var delegate: ProfessionalLikedDelegate?
    
    var spinner = UIActivityIndicatorView() {
           didSet {
               spinner.hidesWhenStopped = true
               spinner.tintColor = Colors.ButtonGreen
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        liked = professional.isLikedByMe
        liked ? likeButton.setImage(#imageLiteral(resourceName: "heart_filled_big"), for: .normal) : likeButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        loadReviews()
        likeCountLabel.text = "\(professional.likes ?? 0)"
        servicesCountLabel.text = "\(professional.servicesCount ?? 0)"
        commentsCountLabel.text = "\(professional.reviewsWithCommentsCount ?? 0)"
        reviewAverageLabel.text = "\(Int(professional.averageReviews ?? 0))"
        professionalNameLabel.text = professional.firstName + " " + professional.lastName
        guard let url = URL(string: professional.avatarURL ?? "") else {
            return
        }
        professionalImageView.hnk_setImageFromURL(url, placeholder: Constants.userPlaceholder)
    }
    
    @IBAction func likeAction(_ sender: Any) {
        ALoader.show()
        let params = ["professional_id": professional.id]
        HTTPClient.shared.request(method: .POST, path: .likeProfessional, data: params) { (response: DefaultResponseAsString?, error) in
            ALoader.hide()
            self.liked.toggle()
            self.delegate?.didLikedProfessional(professionalId: self.professional.id, liked: self.liked)
            self.liked ? self.likedHandler() : self.unlikeHandler()
        }
    }
    
    private func loadReviews() {
        spinner.startAnimating()
        ALoader.show()
        let params = ["professional_id": professional.id]
        HTTPClient.shared.request(method: .POST, path: .professionalReviewsList, data: params) { (response: ProfessionalReviewsListResponse?, error) in
              ALoader.hide()
            self.spinner.stopAnimating()
            self.comments = response?.data.data ?? []
            self.commentsTableView.backgroundView = self.comments.isEmpty ? self.emptyCommentsView : nil
            self.commentsTableView.reloadData()
          }
    }
    
    private lazy var emptyCommentsView: UIView = {
      let lbl = UILabel()
        lbl.font = AFont.with(size: 13, weight: .regular)
        lbl.textColor = Colors.ButtonGreen
        lbl.text = "El profesional aún no cuenta con comentarios."
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.frame = commentsTableView.bounds
        return lbl
    }()
    
    private func likedHandler() {
        showLottieSuccess()
        self.likeButton.setImage(#imageLiteral(resourceName: "heart_filled_big"), for: .normal)
        likeCountLabel.text = "\((Int(likeCountLabel.text  ?? "0" ) ?? 0) + 1)"
    }
    
    private func unlikeHandler() {
        self.likeButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        likeCountLabel.text = "\((Int(likeCountLabel.text  ?? "0" ) ?? 0) - 1)"
    }
    
    private func showLottieSuccess() {
        let lottieView = AnimationView(name: "like_aruba")
        lottieView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        lottieView.contentMode = .scaleAspectFit
        view.addSubview(lottieView)
        lottieView.center = view.center
        lottieView.play { (_) in
            lottieView.removeFromSuperview()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ProfesionalDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryServiceCell") as? HistoryServiceTableViewCell else {
            return UITableViewCell()
        }
        return configure(cell: cell, with: comment)
    }
    
    
    private func configure(cell: HistoryServiceTableViewCell, with data: RatingData) -> HistoryServiceTableViewCell {
        cell.serviceNameLabel.text = data.text
        cell.serviceDescriptionLabel.text = data.createdAt
        cell.serviceImageView?.image = Constants.userPlaceholder
        cell.selectionStyle = .none
        guard let avatar = data.reviewer.avatarURL, let url = URL(string: avatar) else { return cell }
        cell.serviceImageView?.hnk_setImageFromURL(url, placeholder: Constants.userPlaceholder)
        return cell
    }
}
