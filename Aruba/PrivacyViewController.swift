//
//  PrivacyViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 1/20/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView! {
        didSet {
            guard let url = URL(string: "https://aruba.com.py/terminos.php") else { return }
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            guard let url = URL(string: "https://aruba.com.py/terminos.php") else { return }
            webView.loadRequest(URLRequest(url: url))
        } else if sender.selectedSegmentIndex == 1 {
            guard let url = URL(string: "https://aruba.com.py/politicas.php") else { return }
            webView.loadRequest(URLRequest(url: url))
        } else {
            guard let url = URL(string: "https://aruba.com.py/preguntas.php") else { return }
            webView.loadRequest(URLRequest(url: url))
        }
    }
    

}
