//
//  ServiceCategorySelectionPopupTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/7/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

protocol ServiceCategorySelectionDelegate: class {
        func didPressContinue()
        func didPressCancel()
}


struct ServiceCategorySelectionData {
    var address: String
    var addressId: Int
    var clientName: String
    var clientType: ClientType?
}

class ServiceCategorySelectionPopupTableViewController: APopoverTableViewController {

    @IBOutlet weak var serviceCategoryTitleLabel: UILabel!
    @IBOutlet weak var closeView: UIView! {
        didSet {
            closeView.clipsToBounds = true
            closeView.layer.cornerRadius = 12.5
        }
    }
    
    @IBOutlet weak var addressTextField: ATextField!
    @IBOutlet weak var clientNameTextField: ATextField!
    
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var manImageView: UIImageView!
    @IBOutlet weak var womanImageView: UIImageView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var manView: UIView!
    @IBOutlet weak var womanView: UIView!
    
    weak var delegate: ServiceCategorySelectionDelegate?
    
    var data: ServiceCategorySelectionData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.text = data?.address
        clientNameTextField.text = data?.clientName
        
    }

    @IBAction func closeAction(_ sender: UIButton) {
        delegate?.didPressCancel()
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
