//
//  ViewController.swift
//  Clima
//
//  Created by Gregor Kramer on 01.09.2020.
//  Copyright © 2020 Gregor Kramer. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    
    func didUpdateWeather(weather: WeatherModel) {
        
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.currentCondition)
            self.temperatureLabel.text = weather.currentTemp
            self.cityLabel.text = weather.currentCity
        }

    }
    
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
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
}

