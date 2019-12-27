//
//  HistoryDetailsViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/27/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

struct HistoryDetailsViewModel {
    let services: [Service]
    let professionalName: String
    let date: String
    let time: String
    let duration: String
    let address: String
    let paymentMethod: String
    let total: String
    let canCancelAppointment: Bool
    let appointmentId: Int
    
    init (appointment: Appointment) {
        services = appointment.services ?? []
        professionalName = ""
        date = appointment.date
        time = appointment.hourStartPretty
        duration = "\(appointment.duration)"
        address = appointment.fullAddress
        paymentMethod = appointment.transaction.transactionableType
        total = "\(appointment.price)"
        canCancelAppointment = appointment.currentStateID == 1
        appointmentId = appointment.id
    }
}

class HistoryDetailsViewController: UIViewController {
    
    @IBOutlet weak var cancelButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var professionalLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
            tableView.dataSource = self
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    // Inject on prepareForSegue
    var viewModel: HistoryDetailsViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    private func setupView() {
        professionalLabel.text = "Profesional: \(viewModel.professionalName)"
        dateLabel.text = "Fecha: \(viewModel.date)"
        timeLabel.text = "Hora: \(viewModel.time)"
        durationLabel.text = "Tiempo estimado: \(viewModel.duration)"
        addressLabel.text = "Dirección: \(viewModel.address)"
        paymentMethodLabel.text = "Método de pago: \(viewModel.paymentMethod)"
        totalLabel.text = "Total: \(viewModel.total)"
        cancelButtonHeightConstraint.constant = viewModel.canCancelAppointment ? 40 : 0
        
    }
    
    @IBAction func cancelAction(_ sender: AButton) {
        AlertManager.showNotice(in: self, title: "Atención", description: "¿Estas seguro que quieres cancelar esta reserva?", textFieldPlaceholder: "Motivo de cancelación", acceptButtonTitle: "Cancelar Reserva") { motive in
            self.cancelAppointment(reason: motive)
        }
    }
    
    private func cancelAppointment(reason: String) {
        let params: [String: Any] = ["id": viewModel.appointmentId,
                                     "cancel_reason": reason]
        ALoader.show()
        HTTPClient.shared.request(method: .POST, path: .cancelAppointment, data: params) { (response: DefaultResponseAsString?, error) in
            ALoader.hide()
            if let _ = response {
                AlertManager.showNotice(in: self, title: "Listo", description: "La reserva ha sido cancelada.") {
                    self.navigationController?.popViewController(animated: true)
                }
            } else if let error = error {
                AlertManager.showNotice(in: self, title: "Lo sentimos", description: error.message)
            }
        }
        
    }
    
}

extension HistoryDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let service = viewModel.services[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            return configure(cell: cell, service: service)
        }
        return configure(cell: cell, service: service)
    }
    
    private func configure(cell: UITableViewCell, service: Service) -> UITableViewCell {
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        cell.textLabel?.text = service.displayName
        cell.textLabel?.font = AFont.with(size: 17, weight: .regular)
        cell.detailTextLabel?.text = "Duración aproximada de \(service.duration/60) minutos"
        cell.detailTextLabel?.font = AFont.with(size: 13, weight: .regular)
        cell.imageView?.image = Constants.imagePlaceholder
        cell.selectionStyle = .none
        guard let url = URL(string: service.imageURL) else { return cell}
        cell.imageView?.hnk_setImageFromURL(url, placeholder: Constants.imagePlaceholder)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.services.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Servicios Solicitados"
    }
    
    
    
}
