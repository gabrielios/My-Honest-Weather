//
//  ForecastModel.swift
//  My Honest Weather
//
//  Created by Gleb Gribov on 23.02.2022.
//

import Foundation
import RxCocoa
import RxSwift

class ForecastModel {
    let forecastInfo: BehaviorRelay<ForecastResponse?> = BehaviorRelay(value: nil)
    let forecastError: BehaviorRelay<State> = BehaviorRelay(value: .waiting)
    
    enum State {
        case loading
        case waiting
        case success
        case error
    }
}
