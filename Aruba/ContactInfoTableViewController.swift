//
//  ContactInfoTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 1/20/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit
import MessageUI

class ContactInfoTableViewController: APopoverTableViewController {
    
    @IBOutlet weak var mailButton: AButton! {
        didSet {
            mailButton.buttonColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    @IBOutlet weak var webButton: AButton! {
        didSet {
            webButton.buttonColor = #colorLiteral(red: 0.7519621253, green: 0.6642433405, blue: 0.6041884422, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
    }
    
    @IBAction func phoneAction(_ sender: Any) {
        callNumber(phoneNumber: "+595984445004")
    }
    
    @IBAction func webAction(_ sender: Any) {
        if let url = URL(string: "https://aruba.com.py"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func mailAction(_ sender: Any) {
        sendEmail()
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["hola@aruba.com.py"])
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
}


extension ContactInfoTableViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
