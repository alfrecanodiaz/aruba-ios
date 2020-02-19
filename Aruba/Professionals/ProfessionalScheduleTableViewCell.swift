//
//  ProfessionalScheduleTableViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 2/15/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit
import Cosmos

struct ProfessionalScheduleCellViewModel {
    let availableSchedules: [Int]
    let professionalName: String
    let professionalAvatarUrl: String
    let professionalRating: Int
    let professional: Professional
    let index: Int
    var selectedSchedule:Int?
}

protocol ProfessionalScheduleTableViewCellDelegate: NSObject {
    func didChangeSelectedSchedules(index: Int, selectedSchedule: Int?)
}

class ProfessionalScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.applyshadow(cornerRadius: 20)
        }
    }
    @IBOutlet weak var noSchedulesLabel: UILabel!
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 5
            containerView.clipsToBounds = true
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = Colors.Greens.borderLine.cgColor
        }
    }
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var avatarImageView: ARoundImage!
    @IBOutlet weak var professionalNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.register(
                UINib(nibName: "ProfessionalScheduleTimeCollectionViewCell", bundle: nil),
                forCellWithReuseIdentifier: ProfessionalScheduleTimeCollectionViewCell.Constants.reuseIdentifier
            )
            if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.itemSize = CGSize(width: 70, height: 20)
//                flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
        }
    }
    @IBOutlet weak var ratingCountLabel: UILabel!
    
    enum Constants {
        static let reuseIdentifier = "professionalScheduleReuseID"
    }
    
    var viewModel: ProfessionalScheduleCellViewModel? {
        didSet {
            configureCell()
        }
    }
    
    var index: Int = 0
    
    weak var delegate: ProfessionalScheduleTableViewCellDelegate?
    
    private func configureCell() {
        guard let viewModel = viewModel else { return }
        cosmosView.rating = viewModel.professional.averageReviews ?? 0
        index = viewModel.index
        professionalNameLabel.text = viewModel.professionalName
        collectionView.reloadData()
        noSchedulesLabel.isHidden = !viewModel.availableSchedules.isEmpty
        ratingCountLabel.text = viewModel.professionalRating > 0
            ? "(\(viewModel.professional.reviewsCount ?? 0) reviews)"
        : "Sin reviews."
        if let selected = viewModel.selectedSchedule {
            collectionView.scrollToItem(at: IndexPath(item: selected, section: 0), at: .top, animated: true)
        }
        guard let url = URL(string: viewModel.professionalAvatarUrl) else { return }
        avatarImageView.hnk_setImageFromURL(url, placeholder: GlobalConstants.userPlaceholder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

extension ProfessionalScheduleTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.availableSchedules.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfessionalScheduleTimeCollectionViewCell.Constants.reuseIdentifier,
            for: indexPath
            ) as? ProfessionalScheduleTimeCollectionViewCell, let viewModel = viewModel else {
                return UICollectionViewCell()
        }
        cell.timeLabel.text = viewModel.availableSchedules[indexPath.item].asHourMinuteString()
        var selected: Bool = false
        if viewModel.selectedSchedule == indexPath.item {
            selected = true
        }
        cell.setSelected(selected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        if viewModel.selectedSchedule != indexPath.item {
            self.viewModel?.selectedSchedule =  indexPath.item
        } else {
            self.viewModel?.selectedSchedule = nil
        }
        delegate?.didChangeSelectedSchedules(index: index, selectedSchedule: self.viewModel?.selectedSchedule)
    }
    
}
extension UIView {
    func applyshadow(cornerRadius: CGFloat){
        clipsToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
    }
}
