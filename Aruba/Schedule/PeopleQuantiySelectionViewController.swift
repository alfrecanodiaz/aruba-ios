//
//  PeopleQuantiySelectionViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/8/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class PeopleQuantiySelectionViewController: UIViewController {


    @IBOutlet weak var womenView: PeopleQuantityView!
    @IBOutlet weak var menView: PeopleQuantityView!
    @IBOutlet weak var childrenView: PeopleQuantityView!
    @IBOutlet weak var nextBtn: AButton!
    
    struct Segues {
        static let ServiceSelection = "showServiceSelection"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        title = "Cantidad De Personas"
        womenView.configure(for: .Woman)
        womenView.delegate = self
        menView.configure(for: .Men)
        menView.delegate = self
        childrenView.configure(for: .Children)
        childrenView.delegate = self
        nextBtn.setEnabled(false)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ServiceSelection, let dvc = segue.destination as? ServiceSelectionViewController {
            
            var persons: [Person] = []
            
            var i = 0
            while i < womenView.currentCount {
                persons.append(Person(gender: .Women, index: i + 1))
                i += 1
            }
            i = 0
            while i < menView.currentCount {
                persons.append(Person(gender: .Man, index: i + 1))
                i += 1
            }
            i = 0
            while i < childrenView.currentCount {
                persons.append(Person(gender: .Children, index: i + 1))
                i += 1
            }
            
            dvc.persons = persons
        }
    }

}

extension PeopleQuantiySelectionViewController: PeopleQuantityViewDelegate {
    func quantityDidChange(for peopleQuantityView: PeopleQuantityView, quantity: Int) {
        if womenView.currentCount == 0 && childrenView.currentCount == 0 && menView.currentCount == 0 {
            nextBtn.setEnabled(false)
        } else {
            nextBtn.setEnabled(true)
        }
    }
}
