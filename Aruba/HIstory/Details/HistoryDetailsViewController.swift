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
    let canRateAppointment: Bool
    let professionalAvatarURL: String
    let professionalId: Int
    
    init (appointment: Appointment) {
        services = appointment.services ?? []
        if let professional = appointment.professional {
            professionalName = professional.firstName + " " + professional.lastName
            professionalAvatarURL = professional.avatarURL ?? ""
            professionalId = professional.id
        } else {
            professionalName = ""
            professionalAvatarURL = ""
            professionalId = 0
        }
        date = appointment.date
        time = appointment.hourStartPretty
        duration = "\(appointment.duration/60) minutos"
        address = appointment.fullAddress
        paymentMethod = appointment.transaction.readableTransactionType()
        total =  Int(appointment.price).asGs() ?? ""
        canCancelAppointment = appointment.currentStateID == 1
        appointmentId = appointment.id
        canRateAppointment = appointment.currentStateID == 4

    }
}

class HistoryDetailsViewController: BaseViewController {
    
    @IBOutlet weak var professionalAvatarImageView: ARoundImage!
    @IBOutlet weak var cancelButton: AButton!
    @IBOutlet weak var rateButton: AButton!
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
            tableView.register(UINib(nibName: "HistoryServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryServiceCell")
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
        cancelButton.isHidden = !viewModel.canCancelAppointment
        rateButton.isHidden = !viewModel.canRateAppointment
        guard let url = URL(string: viewModel.professionalAvatarURL) else { return }
        professionalAvatarImageView.kf.setImage(with: url, placeholder: GlobalConstants.userPlaceholder)

    }
    
    @IBAction func cancelAction(_ sender: AButton) {
        AlertManager.showNotice(in: self, title: "Atención",
                                description: "¿Estas seguro que quieres cancelar esta reserva?",
                                textFieldPlaceholder: "Motivo de cancelación",
                                acceptButtonTitle: "Cancelar Reserva") { motive in
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
    
    @IBAction func rateAction(_ sender: AButton) {
        guard let popup = storyboard?.instantiateViewController(withIdentifier: "RateProfessionalTableViewControllerID") as? RateProfessionalTableViewController else { return }
        popup.viewModel = RateProfessionalViewModel(professionalName: viewModel.professionalName,
                                                    professionalAvatarURL: viewModel.professionalAvatarURL,
                                                    professionalId: viewModel.professionalId)
        popup.modalPresentationStyle = .popover
        addBlackBackgroundView()
        let popover = popup.popoverPresentationController
        popover?.delegate = self
        popover?.permittedArrowDirections = .init(rawValue: 0)
        popover?.sourceView = view
        popover?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        popup.delegate = self
        present(popup, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource
extension HistoryDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let service = viewModel.services[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryServiceCell") as? HistoryServiceTableViewCell else {
            return UITableViewCell()
        }
        return configure(cell: cell, service: service)
    }
    
    private func configure(cell: HistoryServiceTableViewCell, service: Service) -> HistoryServiceTableViewCell {
        cell.serviceNameLabel.text = service.displayName
        cell.serviceDescriptionLabel.text = "Duración aproximada de \(service.duration/60) minutos"
        cell.selectionStyle = .none
        guard let url = URL(string: service.imageURL) else { return cell }
        cell.serviceImageView.kf.setImage(with: url, placeholder: GlobalConstants.imagePlaceholder)

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

extension HistoryDetailsViewController: RateProfessionalPopupDelegate {
    func didClosePopup() {
        removeBlackBackgroundView()
    }
    
    func didRateProfessional() {
        removeBlackBackgroundView()
    }
}

extension String {
    func asMinutes() -> String? {
        let asInt = Int(self) ?? 0
        return String(asInt/60)
    }
}
