//
//  ViewController.swift
//  Weather
//
//  Created by Michal Červenec on 30/03/2022.
//

import UIKit
import CoreLocation


class WeatherDetailViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    @IBAction func search(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() {
            present(navigationController, animated: true)
        }
    }
    
    // MARK: - Variables
    var place: Place?
    var refreshControl = UIRefreshControl()
    var location: CurrentLocation?
    var days = [DailyWeather]()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        activityIndicator.startAnimating()
        setupTableView()
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
}

//MARK: - Actions
extension WeatherDetailViewController {
    
    
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
}

//MARK: - Request and location handling
private extension WeatherDetailViewController {
    @objc func loadData() {
        guard let location = location else {
            return
        }
        
        RequestManager.shared.getWeatherData(for: location.coordinates) { [weak self] response in
            guard let self = self else {return}
            
            self.tableView.isHidden = false
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            
            switch response {
            case .success(let weatherData):
                self.setupView(with: weatherData.current)
                self.days = weatherData.days
                self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func aquireLocation() {
        LocationManager.shared.getLocation { [weak self] location, error in
            guard let self = self else {return}
            
            if let error = error {
                self.activityIndicator.stopAnimating()
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


