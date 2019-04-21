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
        womenView.configure(for: .women)
        womenView.delegate = self
        menView.configure(for: .man)
        menView.delegate = self
        childrenView.configure(for: .children)
        childrenView.delegate = self
        nextBtn.setEnabled(false)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ServiceSelection, let dvc = segue.destination as? ServiceSelectionViewController {
            var persons: [Person] = []
            var count = 0
            while count < womenView.currentCount {
                persons.append(Person(gender: .women, index: count + 1))
                count += 1
            }
            count = 0
            while count < menView.currentCount {
                persons.append(Person(gender: .man, index: count + 1))
                count += 1
            }
            count = 0
            while count < childrenView.currentCount {
                persons.append(Person(gender: .children, index: count + 1))
                count += 1
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
