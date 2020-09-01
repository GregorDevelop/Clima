//
//  WeatherData.swift
//  Clima
//
//  Created by Gregor Kramer on 01.09.2020.
//  Copyright © 2020 Gregor Kramer. All rights reserved.
//

import Foundation


struct WeatherData: Codable {
    
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
}

struct Main: Codable  {
    let temp: Double
}
