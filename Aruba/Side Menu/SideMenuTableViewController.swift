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
        case 7:
            handleLogout()
        default:
            break
        }
    }

    private func handleProfile() {
        performSegue(withIdentifier: Segues.Profile, sender: self)
    }
    
    private func handleAppointments() {
        performSegue(withIdentifier: Segues.History, sender: self)
    }

    private func handleLogout() {
        AuthManager.logout()
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LandingViewControllerID")
        transition(to: vc, completion: nil)
    }

}
