//
//  SearchViewController.swift
//  Weather
//
//  Created by Michal Červenec on 19/05/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tablView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
    }
    
    func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.searchBar.delegate = self
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        LocationManager.shared.getLocalSearch(from: searchText)
    }
    
}
