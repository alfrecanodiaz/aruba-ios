//
//  HourAssignmentViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/14/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

struct Hour {
    let hourString: String
}

class HourAssignmentViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var genderContainerView: UIView! {
        didSet {
            genderContainerView.layer.cornerRadius = 10
            genderContainerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var dateContainerView: UIView! {
        didSet {
            dateContainerView.layer.cornerRadius = 25
            dateContainerView.clipsToBounds = true
        }
    }

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateDescriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var date: AssignmentDate!
    
    var hours: [Hour] = []
    var selectedHourIndex: Int = 0
    private let spacing: CGFloat = 0
    private var animationDone: Bool = false
    struct Cells {
        static let Hour = "HourCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_PY")
        dateFormatter.dateFormat = "EEEE"
        
        if date.dateInFuture == 0 {
            dateLabel.text = "HOY"
        } else if date.dateInFuture == 1 {
            dateLabel.text = "MAÑANA"
        } else if date.dateInFuture == 7 {
            dateLabel.text = "OTRA FECHA"
        } else {
            dateLabel.text = dateFormatter.string(for: date.date)?.uppercased()
        }
        dateFormatter.dateFormat = "EEEE dd/MM/yyyy"
        dateDescriptionLabel.text = dateFormatter.string(from: date.date).uppercased()
        
        hours = [Hour(hourString: "7:00"),Hour(hourString: "7:30"),Hour(hourString: "8:00"),Hour(hourString: "8:30"),Hour(hourString: "9:00"),Hour(hourString: "9:30"),Hour(hourString: "10:00"),Hour(hourString: "10:30"),Hour(hourString: "11:00"),Hour(hourString: "11:30")]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 16
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.collectionView {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: collection.bounds.height/5 - 10)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.Hour, for: indexPath) as! HourCollectionViewCell
        cell.configure(hour: hours[indexPath.row],selected: selectedHourIndex == indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedHourIndex = indexPath.row
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !animationDone {
            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: 0, y: 40)
            UIView.animate(withDuration: 0.5, delay: 0.05*Double(indexPath.row), usingSpringWithDamping: 0.87, initialSpringVelocity: 0.78, options: [.curveEaseIn, .allowUserInteraction], animations: {
                cell.transform = CGAffineTransform.identity
                cell.alpha = 1
            }) { (end) in
                self.animationDone = true
            }
        }
    }

}
