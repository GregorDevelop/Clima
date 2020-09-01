//
//  WeatherManager.swift
//  Clima
//
//  Created by Gregor Kramer on 01.09.2020.
//  Copyright © 2020 Gregor Kramer. All rights reserved.
//

import Foundation

import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1e8871823932b7f5a3315f91f2d1a98d&units=metric&lang=ru"
    
    
    func fetchWeather(cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1. Create a URL
        
        if let url = URL(string: urlString) {
            
            // 2.Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            // 3. Give the URLSession a task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if  error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                    
                }
            }
            
            // 4. Start task
            task.resume()
        }
        
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
           let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let city = decodedData.name

            let weather = WeatherModel(conditionId: id, temperature: temp, cityName: city)

            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    

}
