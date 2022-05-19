//
//  ViewController.swift
//  Weather
//
//  Created by Michal Červenec on 30/03/2022.
//

import UIKit
import CoreLocation

enum State {
    case loading
    case error(String)
    case success(WeatherResponse)
}

class WeatherDetailViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!

    // MARK: - Variables
    var place: Place?
    var refreshControl = UIRefreshControl()
    var location: CurrentLocation?
    var days = [DailyWeather]()
    var state: State = .loading {
        didSet {
            reloadState()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        setupTableView()
        aquireLocation()
        
        LocationManager.shared.onAuthorizationChange { authorization in
            if authorization{
                self.aquireLocation()
            }
        }
        
        if LocationManager.shared.denied {
            presentAlert()
        } else {
            aquireLocation()
        }
        
        setupTableView()
    }
}

//MARK: - Actions
private extension WeatherDetailViewController {
    
    @IBAction func reload(_ sender: Any) {
        loadData()
    }
    
    @IBAction func search(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() {
            present(navigationController, animated: true)
        }
    }
    
    @IBAction func addToFavorites(_ sender: Any) {
        let defaults = UserDefaults.standard
        var placesArray = defaults.object(forKey: "Favorites") as? [String] ?? [String]()
        if let currentPlace = location?.city {
            if !placesArray.contains(currentPlace) {
                placesArray.append(currentPlace)
            }
        }
        defaults.set(placesArray, forKey: "Favorites")
    }
}

//MARK: - setup functions

private extension WeatherDetailViewController {
    func setupTableView() {
        tableView.isHidden = true
        activityIndicator.startAnimating()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        tableView.register(UINib(nibName: WeatherTableViewCell.classString, bundle: nil),
                           forCellReuseIdentifier: WeatherTableViewCell.classString)
    }
    
    func setupView(with currentWeather: CurrentWeather) {
        locationLabel.text = location?.city
        dateLabel.text = DateFormatter.mediumDateFormater.string(from: currentWeather.date)
        temperatureLabel.text = currentWeather.temperatureWithCelsius
        feelsLikeLabel.text = currentWeather.feelsLikeWithCelsius
        weatherStatusLabel.text = currentWeather.weather.first?.description
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Location manager", message: "Location is disabled", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settingsUrl) else {
                return
            }
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true)
    }
    
    func reloadState() {
        
        switch state {
            
        case .loading:
            activityIndicator.startAnimating()
            tableView.isHidden = true
            emptyView.isHidden = true
            
        case .error(let message):
            refreshControl.endRefreshing()
            activityIndicator.stopAnimating()
            tableView.isHidden = true
            emptyView.isHidden = false
            errorMessageLabel.text = message
            
        case .success(let weatherData):
            refreshControl.endRefreshing()
            activityIndicator.stopAnimating()
            tableView.isHidden = false
            emptyView.isHidden = true
            setupView(with: weatherData.current)
            days = weatherData.days
            tableView.reloadSections(IndexSet(integer: 0), with: .fade)

            
        }
    }
}

//MARK: - Request and location handling
private extension WeatherDetailViewController {
    @objc func loadData() {
        guard let location = location else {
            return
        }
        state = .loading
        
        RequestManager.shared.getWeatherData(for: location.coordinates) { [weak self] response in
            guard let self = self else {return}
            
            switch response {
            case .success(let weatherData):
                self.state = .success(weatherData)

            case .failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    func aquireLocation() {
        LocationManager.shared.getLocation { [weak self] location, error in
            guard let self = self else {return}
            
            if let error = error {
                self.state = .error(error.localizedDescription)
            } else if let location = location {
                self.location = location
                self.loadData()
            }
        }
    }
}

// MARK: - Table View Data Source

extension WeatherDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.classString, for: indexPath) as? WeatherTableViewCell
        else {
            return UITableViewCell()
        }
        
        weatherCell.setupCell(with: days[indexPath.row])
        
        return weatherCell
    }
}


