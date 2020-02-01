//
//  ProfessionalsViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 1/2/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit
import PageMenu

class ProfessionalsViewController: UIViewController {
    
    @IBOutlet weak var pageMenuContainerView: UIView!
    
    var controllerArray : [ProfessionalsTableViewController] = []
    var pageMenu : CAPSPageMenu?
    var searchBar: UISearchBar?
    
    var categories: [CategoryViewModel] = [] {
        didSet {
            setupPageMenu()
        }
    }
    
    var professionalsViewModel: [[Professional]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureSearchBar()
        fetchServiceCategories()
    }
    
    private func configureSearchBar() {
        
        
    }
    
    private func setupView() {
        searchBar = UISearchBar()
        searchBar?.placeholder = "Buscar Profesionales"
        searchBar?.delegate = self
        searchBar?.tintColor = .white
        navigationItem.titleView = searchBar
    }
    
    @objc private func searchProfessional() {
        
    }
    
    private func setupPageMenu() {
        _ = pageMenuContainerView.subviews.map({$0.removeFromSuperview()})
        controllerArray = categories.compactMap { viewModel in
            if viewModel.enabled {
                let vc = storyboard?.instantiateViewController(withIdentifier: "ProfessionalsTableViewControllerID") as? ProfessionalsTableViewController
                vc?.title = viewModel.title
                vc?.serviceCategoryId = viewModel.id
                vc?.loadViewIfNeeded()
                return vc
            } else {
                return nil
            }
        }
        
        let parameters: [CAPSPageMenuOption] = [
            .useMenuLikeSegmentedControl(false),
            .menuItemSeparatorPercentageHeight(0.1),
            .menuItemWidthBasedOnTitleTextWidth(true),
            .menuHeight(60),
            .menuItemFont(AFont.with(size: 16, weight: .regular)),
            .scrollMenuBackgroundColor(Colors.ButtonDarkGray),
            .selectionIndicatorColor(Colors.ButtonGreen),
            .centerMenuItems(true)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray,
                                frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.bounds.width,
                                              height: view.bounds.height),
                                pageMenuOptions: parameters)
        self.addChild(pageMenu!)
        pageMenu?.didMove(toParent: self)
        self.pageMenuContainerView.addSubview(pageMenu!.view)
    }
    
    private func fetchServiceCategories() {
        ALoader.show()
        HTTPClient.shared.request(method: .POST, path: .serviceCategoryList) { (categoryList: ServiceCategoryListResponse?, error) in
            ALoader.hide()
            if let categories = categoryList {
                self.categories = categories.data.map({CategoryViewModel(category: $0)})
            } else if let error = error {
                AlertManager.showErrorNotice(in: self, error: error) {
                    self.fetchServiceCategories()
                }
            }
        }
    }
    
    private func search(text: String) {
        guard !text.isEmpty else {
            _ = controllerArray.map({
                $0.searching = false
                $0.tableView.reloadData()
            })
            return
        }
        _ = controllerArray.map({
            $0.searching = true
            $0.filteredViewModel = $0.viewModel.filter({($0.firstName + " " + $0.lastName).containsIgnoringCase(find: text)})
        })
    
    }
    
}

extension ProfessionalsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(text: searchBar.text ?? "")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(text: "")
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}


extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
