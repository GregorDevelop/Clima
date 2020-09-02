//
//  ViewController.swift
//  Clima
//
//  Created by Gregor Kramer on 01.09.2020.
//  Copyright © 2020 Gregor Kramer. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController {


    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
           searchTextField.endEditing(true)
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           searchTextField.endEditing(true)
           return true
       }
       
       func textFieldDidEndEditing(_ textField: UITextField) {
           let city = searchTextField.text!
           weatherManager.fetchWeather(cityName: city)
           searchTextField.text = ""
       }
       
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
           if textField.text != "" {
               textField.placeholder = "Search"
               return true
           } else {
               textField.placeholder = "Type some city"
               return false
           }
       }
       
       @IBAction func locationPressed(_ sender: UIButton) {
           locationManager.requestLocation()
       }
}

// MARK: - WeatherManagerDelegate


extension WeatherViewController: WeatherManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.currentCondition)
            self.temperatureLabel.text = weather.currentTemp
            self.cityLabel.text = weather.currentCity
        }

    }
}


// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchWeather(lat: lat, lon: lon)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error) 
    }
    
}

