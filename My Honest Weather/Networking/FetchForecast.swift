//
//  FetchForecast.swift
//  My Honest Weather
//
//  Created by Gleb Gribov on 23.02.2022.
//

import Foundation

class FetchForecast {
    static let shared = FetchForecast()
    
    func fetchForecast(lat: String, long: String, completion: @escaping (ForecastResponse) -> (), errorState: @escaping (Error?) -> ()) {
        let url = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)&units=metric&appid=8c238515c5a14d3bd253009388023a7b"
        if let urlObj = URL(string: url) {
            var request = URLRequest(url: urlObj)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        errorState(error)
                    }else {
                        do {
                            if let data = data {
                                let forecastData = try JSONDecoder().decode(ForecastResponse.self, from: data)
                                DispatchQueue.main.async {
                                    completion(forecastData)
                                }
                            }
                        } catch {
                            errorState(error)
                        }
                    }
                }
            }).resume()
        }
    }
}
