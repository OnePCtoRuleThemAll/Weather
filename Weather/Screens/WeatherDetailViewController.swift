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
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    // MARK: - Variables
    
    var refreshControl = UIRefreshControl()
    
    var days = [DailyWeather]()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let currentDate = Date()
        dateLabel.text = formatter.string(from: currentDate)
        
        LocationManager.shared.getLocation { [weak self] location, error in
            guard let self = self else {return}
            
            if let error = error {
                print("Error here")
            } else if let location = location {
                RequestManager.shared.getWeatherData(for: location.coordinates) { response in
                    
                    switch response {
                    case .success(let weatherData):
                        self.setupView(with: weatherData.current)
                        self.days = weatherData.days
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
                self.locationLabel.text = location.city
            }
            
            
        }
        
        tableView.register(UINib(nibName: WeatherTableViewCell.classString, bundle: nil),
                           forCellReuseIdentifier: WeatherTableViewCell.classString)
    }
    func setupView(with currentWeather: CurrentWeather) {
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


