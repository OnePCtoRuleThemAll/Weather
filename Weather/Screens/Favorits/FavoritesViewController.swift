//
//  FavoritsViewController.swift
//  Weather
//
//  Created by Michal Červenec on 19/05/2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var favorites = [String]()
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    func setupTable() {
        let defaults = UserDefaults.standard
        favorites = defaults.object(forKey: "Favorites") as? [String] ?? [String]()
        tableView.reloadData()
        tableView.isHidden = false
        tableView.refreshControl = refreshControl
    }
}

extension FavoritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let favoritesCell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath)
        let place = favorites[indexPath.row]

        favoritesCell.textLabel?.text = place

        return favoritesCell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
}
