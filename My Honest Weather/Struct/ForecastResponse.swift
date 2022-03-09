//
//  ForecastResponse.swift
//  My Honest Weather
//
//  Created by Gleb Gribov on 23.02.2022.
//

import Foundation

struct ForecastResponse: Codable {
    let cod: String?
    let list: [Forecast]?
    let city: City?
}

struct Forecast: Codable {
    let dt: Int?
    let main: Main?
    let weather: [Weather]?
    let wind: Wind?
    let rain: Rain?
}

struct City: Codable {
    let name: String?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}

struct Weather: Codable {
    let main: String?
    let description: String?
    let icon: String?
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}

struct Rain: Codable {
    let rainInterval: Double?
    
    enum CodingKeys: String, CodingKey {
        case rainInterval = "3h"
    }
}

struct Main: Codable {
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Int?
    let humidity: Int?
}
