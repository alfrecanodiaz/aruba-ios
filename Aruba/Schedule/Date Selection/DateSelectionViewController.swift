//
//  DateSelectionViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/14/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

struct AssignmentDate {
    
    
    let date: Date
    let dateInFuture: Int
    init(dateInFuture: Int) {
        self.dateInFuture = dateInFuture
        var components = DateComponents()
        components.setValue(dateInFuture, for: .day)
        let futureDate = Calendar.current.date(byAdding: components, to: Date())!
        self.date = futureDate
    }
}

class DateSelectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var genderContainerView: UIView! {
        didSet {
            genderContainerView.layer.cornerRadius = 10
            genderContainerView.clipsToBounds = true
        }
    }
    
    
    var dates: [AssignmentDate] = []
    var selectedDateIndex: Int = 0
    let spacing: CGFloat = 0
    
    private var animationDone: Bool = false

    
    struct Cells {
        static let Date = "DateSelectionCell"
    }
    
    struct Segues {
        static let HourAssignment = "HourAssignmentSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dates = [AssignmentDate(dateInFuture: 0), AssignmentDate(dateInFuture: 1),AssignmentDate(dateInFuture: 2),AssignmentDate(dateInFuture: 3),AssignmentDate(dateInFuture: 4),AssignmentDate(dateInFuture: 5),AssignmentDate(dateInFuture: 6),AssignmentDate(dateInFuture: 7)]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.HourAssignment, let dvc = segue.destination as? HourAssignmentViewController {
            dvc.date = dates[selectedDateIndex]
        }
    }


    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 16
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.collectionView {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: collection.bounds.height/4)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.Date, for: indexPath) as! DateSelectionCollectionViewCell
        cell.configure(aDate: dates[indexPath.row],selected: selectedDateIndex == indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDateIndex = indexPath.row
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
