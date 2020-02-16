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
            shadowView.applyshadow()
        }
    }
    @IBOutlet weak var noSchedulesLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 8
            containerView.clipsToBounds = true
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = Colors.AlertTintColor.cgColor
        }
    }
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var avatarImageView: ARoundImage!
    @IBOutlet weak var professionalNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(
                UINib(nibName: "ProfessionalScheduleTimeCollectionViewCell", bundle: nil),
                forCellWithReuseIdentifier: ProfessionalScheduleTimeCollectionViewCell.Constants.reuseIdentifier
            )
            if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
        }
    }
    
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
        cosmosView.rating = Double(viewModel.professionalRating)
        index = viewModel.index
        professionalNameLabel.text = viewModel.professionalName
        collectionView.reloadData()
        noSchedulesLabel.isHidden = !viewModel.availableSchedules.isEmpty
        guard let url = URL(string: viewModel.professionalAvatarUrl) else { return }
        avatarImageView.hnk_setImageFromURL(url)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
    func applyshadow(){
        clipsToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 20
        ).cgPath
    }
}
