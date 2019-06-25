//
//  HomeTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

struct Category {
    let image: UIImage?
    let title: String
    let color: UIColor

    init(imageName: String, title: String, color: UIColor) {
        image = UIImage(named: imageName)
        self.title = title
        self.color = color
    }
}

struct HomeViewModel {
    var userAddresses: [AddressViewModel] = []
    var user: Usuario?
    let categories = [Category(imageName: "peluqueria_blanco",
                               title: "PELUQUERIA",
                               color: Colors.Peluqueria),
                      Category(imageName: "manicura_blanco",
                               title: "MANICURA/PEDICURA",
                               color: Colors.Manicura),
                      Category(imageName: "estetica_blanco",
                               title: "ESTETICA",
                               color: Colors.Estetica),
                      Category(imageName: "aruba1",
                               title: "MASAJES",
                               color: Colors.Masajes),
                      Category(imageName: "nutricion_blanco",
                               title: "NUTRICIÓN",
                               color: Colors.Nutricion),
                      Category(imageName: "barberia_blanco",
                               title: "BARBERIA",
                               color: Colors.Peluqueria)]

    static func buildFrom(user: UserLoginResponse) -> HomeViewModel {
        let viewModel = HomeViewModel(userAddresses: user.sesion.usuario.ubicaciones.map({AddressViewModel(address: $0)}),
                                      user: user.sesion.usuario)
        return viewModel
    }

    static func buildFrom(user: LoginViewModel) -> HomeViewModel {
        let viewModel = HomeViewModel(userAddresses: user.addresses,
                                      user: user.user.sesion.usuario)
        return viewModel
    }
}

class HomeTableViewController: BaseTableViewController {

    var popup: PopupTableViewController!
    var viewModel: HomeViewModel?

    struct Cells {
        static let Category = "homeCategoryCell"
    }

    struct Segues {
        static let ScheduleService = "scheduleServiceSegue"
    }

    var services: [Servicio] = [] {
        didSet {
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            tableView.endUpdates()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        fetchServices()
//        categories = [Category(imageName: "peluqueria_blanco",
//                               title: "PELUQUERIA",
//                               color: Colors.Peluqueria),
//                      Category(imageName: "manicura_blanco",
//                               title: "MANICURA/PEDICURA",
//                               color: Colors.Manicura),
//                      Category(imageName: "estetica_blanco",
//                               title: "ESTETICA",
//                               color: Colors.Estetica),
//                      Category(imageName: "aruba1",
//                               title: "MASAJES",
//                               color: Colors.Masajes),
//                      Category(imageName: "nutricion_blanco",
//                               title: "NUTRICIÓN",
//                               color: Colors.Nutricion),
//                      Category(imageName: "barberia_blanco",
//                               title: "BARBERIA",
//                               color: Colors.Peluqueria)]
    }

    private func fetchServices() {
        ALoader.show()
        HTTPClient.shared.request(method: .POST, path: .servicesList) { (serviceList: ServicesListResponse?, _) in
            ALoader.hide()
            if let serviceList = serviceList {
                self.services = serviceList.servicios
            } else {

            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.bounds.height - (UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)))/6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.Category, for: indexPath) as? HomeCategoryTableViewCell else { return UITableViewCell() }
        cell.configure(service: services[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = services[indexPath.row]
        guard service.active else {
            let alert = UIAlertController(title: "Lo sentimos", message: "Este servicio aún no se encuentra disponible.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Aceptar", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            return
        }
        guard let _ = viewModel?.user, let viewModel = viewModel else {
            let alert = UIAlertController(title: "Lo sentimos", message: "Debes registrarte para poder acceder a este servicio.", preferredStyle: .alert)
            let register = UIAlertAction(title: "Registrarme", style: .default) { (action) in

            }
            alert.addAction(register)
            let cancel = UIAlertAction(title: "Aceptar", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            return
        }
        popup = showOptionPopup(title: "Dirección del servicio",
                                options: viewModel.userAddresses.map({GenericDataCellViewModel(address: $0)}),
                                delegate: self)
    }

    override func popupDidSelectAccept(selectedIndex: Int) {
        super.popupDidSelectAccept(selectedIndex: selectedIndex)
        popup.dismiss(animated: true) {
            self.performSegue(withIdentifier: Segues.ScheduleService, sender: self)
        }
    }

//        guard let cell = cell as? HomeCategoryTableViewCell else { return }
//        cell.backgroundImageView.layer.cornerRadius = cell.backgroundImageView.bounds.width/2

}
