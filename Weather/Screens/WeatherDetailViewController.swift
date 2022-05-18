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
    
    // MARK: - Variables
    
    var refreshControl = UIRefreshControl()
    var location: CurrentLocation?
    var days = [DailyWeather]()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        activityIndicator.startAnimating()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
             
        LocationManager.shared.onAuthorizationChange { authorization in
            LocationManager.shared.getLocation { [weak self] location, error in
                guard let self = self else {return}
                
                if let error = error {

                } else if let location = location {
                    self.location = location
                    self.loadData()
                }
            }
        }
        
        if LocationManager.shared.denied {
            presentAlert()
        } else {
            LocationManager.shared.getLocation { [weak self] location, error in
                guard let self = self else {return}
                
                if let error = error {

                } else if let location = location {
                    self.location = location
                    self.loadData()
                }
            }
        }
        
        
        tableView.register(UINib(nibName: WeatherTableViewCell.classString, bundle: nil),
                           forCellReuseIdentifier: WeatherTableViewCell.classString)
    }
    
    @objc func loadData() {
        guard let location = location else {
            return
        }
        
        RequestManager.shared.getWeatherData(for: location.coordinates) { response in
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
    
    func setupView(with currentWeather: CurrentWeather) {
        locationLabel.text = location?.city
        dateLabel.text = DateFormatter.mediumDateFormater.string(from: currentWeather.date)
        temperatureLabel.text = currentWeather.temperatureWithCelsius
        feelsLikeLabel.text = currentWeather.feelsLikeWithCelsius
        weatherStatusLabel.text = currentWeather.weather.first?.description
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


