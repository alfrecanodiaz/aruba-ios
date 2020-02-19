//
//  BottomTotalView.swift
//  Aruba
//
//  Created by Javier Rivarola on 2/18/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit

protocol BottomTotalViewDelegate: NSObject {
    func didSelectContinue(view: BottomTotalView)
}

class BottomTotalView: UIView {
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var continueButton: AButton! {
        didSet {
            DispatchQueue.main.async {
                self.continueButton.setEnabled(false, animated: false)
            }
        }
    }
    
    weak var delegate: BottomTotalViewDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    static func build(delegate: BottomTotalViewDelegate?) -> BottomTotalView {
       let view = BottomTotalView.instantiate()
        view.delegate = delegate
        return view
    }
    
    private func commonInit() {
        backgroundColor = Colors.Greens.lightBackground
    }

    @IBAction func continueTouchUpInside(_ sender: AButton) {
        delegate?.didSelectContinue(view: self)
    }
}

extension UINib {
    func instantiate() -> Any? {
        return self.instantiate(withOwner: nil, options: nil).first
    }
}

extension UIView {

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    static func instantiate(autolayout: Bool = true) -> Self {
        // generic helper function
        func instantiateUsingNib<T: UIView>(autolayout: Bool) -> T {
            let view = self.nib.instantiate() as! T
            view.translatesAutoresizingMaskIntoConstraints = !autolayout
            return view
        }
        return instantiateUsingNib(autolayout: autolayout)
    }
}
