//
//  CardPaymentViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/16/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit
import WebKit
protocol CardPaymentDelegate: class {
    func successCardPayment()
    func canceledCardPayment()
}
class CardPaymentViewController: UIViewController {
    
    var cartData: CartData!
    @IBOutlet weak var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView?
    weak var delegate: CardPaymentDelegate?
    
    @IBOutlet weak var cancelButton: AButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator!)
        activityIndicator?.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
        activityIndicator?.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        cancelButton.setEnabled(false)
        activityIndicator?.startAnimating()
        fetchProcessId()
    }
    
    var paymentSuccess: Bool = false
    var processId: Any?
    
    private func fetchProcessId() {
        let params: [String : Any] = [
            "professional_id": cartData.professional.id,
            "hour_start": cartData.hourStartAsSeconds,
            "address_id": cartData.addressId,
            "date": cartData.date,
            "services_id": cartData.servicesIds,
            "payment_type": 2,
            "access_token": AuthManager.getCurrentAccessToken() ?? ""
        ]
        guard let url = URL(string: HTTPClient().baseURL + HTTPClient.Endpoint.bancardPayment.rawValue),
        var request = try? URLRequest(url: url, method: .post) else {
            return
        }
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.addValue("Bearer \(AuthManager.getCurrentAccessToken() ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        webView.configuration.userContentController.add(self, name: "myInterface")
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    @IBAction func cancelAction(_ sender: AButton) {
        cancelPayment()
    }
    
    private func cancelPayment() {
        guard let processId = processId else {
            return
        }
        ALoader.show()
        let params: [String: Any] = ["shop_process_id": processId]
        HTTPClient.shared.request(method: .POST, path: .cancelBancardPayment, data: params) { (response: DefaultResponseAsString?, error) in
            ALoader.hide()
            if let response = response {
                if response.success {
                    self.dismiss(animated: true) {
                        self.delegate?.canceledCardPayment()
                    }
                }
            } else if let error = error {
                AlertManager.showNotice(in: self, title: "Lo sentimos", description: error.message)
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CardPaymentViewController: WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
         print("Message received: \(message.name) with body: \(message.body)")
        processId = message.body
        cancelButton.setEnabled(true)
    }
}

extension CardPaymentViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
        self.activityIndicator = nil
    }
}
