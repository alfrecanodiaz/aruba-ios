//
//  SideMenuTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    struct Segues {
        static let Profile = "profileSegue"
        static let History = "HistorySegue"
        static let Professionals = "ProfessionalsSegue"
        static let ContactInfo = "showContactInfo"
        static let Privacy = "ShowPrivacy"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    func setupView() {
        profileImageView.clipsToBounds = true
        guard let url = URL(string: UserManager.shared.loggedUser?.avatarURL ?? "") else { return }
        profileImageView.hnk_setImageFromURL(url, placeholder: Constants.userPlaceholder)
    }
    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            handleProfile()
        case 2:
            handleAppointments()
        case 3:
            handleProfessionals()
        case 4:
            handlePromotions()
        case 5:
            handleContactInfo()
        case 6:
            handleAbout()
        case 7:
            handleLogout()
        default:
            break
        }
    }
    
    private func handlePromotions() {
        AlertManager.showNotice(in: self, title: "Proximamente", description: "Esta sección estara disponible proximamente!")
    }
    
    private func handleAbout() {
        performSegue(withIdentifier: Segues.Privacy, sender: self)
    }
    
    private func handleContactInfo() {
        performSegue(withIdentifier: Segues.ContactInfo, sender: self)
    }
    
    private func handleProfile() {
        performSegue(withIdentifier: Segues.Profile, sender: self)
    }
    
    private func handleAppointments() {
        performSegue(withIdentifier: Segues.History, sender: self)
    }
    
    private func handleProfessionals(){
        performSegue(withIdentifier: Segues.Professionals, sender: self)
    }
    
    private func handleLogout() {
        AuthManager.logout()
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LandingViewControllerID")
        transition(to: vc, completion: nil)
    }
    
}
