//
//  ForecastViewModel.swift
//  My Honest Weather
//
//  Created by Gleb Gribov on 23.02.2022.
//

import Foundation
import RxSwift
import RxCocoa

class ForecastViewModel {
    var forecastModel = ForecastModel()
    
    func dataFetch(lat: String, long: String) {
        forecastModel.forecastInfo.accept(nil)
        forecastModel.forecastError.accept(.loading)
        
        FetchForecast.shared.fetchForecast(lat: lat, long: long, completion: { data in
            self.forecastModel.forecastInfo.accept(data)
            self.forecastModel.forecastError.accept(.success)
        }, errorState: { error in
            self.forecastModel.forecastError.accept(.error)
        })
    }
}
