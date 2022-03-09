//
//  ViewController.swift
//  My Honest Weather
//
//  Created by Gleb Gribov on 23.02.2022.
//

import UIKit
import CoreLocation
import RxCocoa
import RxSwift
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var loadingActivityView: UIActivityIndicatorView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var forecastInfoLabel: UILabel!
    @IBOutlet weak var forecastTempLabel: UILabel!
    @IBOutlet weak var forecastMinLabel: UILabel!
    @IBOutlet weak var forecastMaxLabel: UILabel!
    @IBOutlet weak var forecastFeelsLabel: UILabel!
    @IBOutlet weak var forecastImageView: UIImageView!
    //Borrom view
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var bottomContainerView: UIView!
    
    
    
    var forecastViewModel = ForecastViewModel()
    let disposeBag = DisposeBag()
    
    var locationManager = CLLocationManager()
    
    var forecastList = [Forecast]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        tabBarController?.delegate = self
        
        forecastViewModel.forecastModel.forecastError.subscribe({ state in
            
            DispatchQueue.main.async {
                if let state = state.element {
                    switch state {
                    case .loading:
                        print("Loading")
                        self.loadingActivityView.isHidden = false
                        break
                    case .waiting:
                        print("Waiting")
                        self.loadingActivityView.isHidden = true
                        break
                    case .error:
                        print("Error")
                        self.loadingActivityView.isHidden = true
                        break
                    case .success:
                        print("Succes")
                        self.loadingActivityView.isHidden = true
                        break
                    }
                }
            }
           
        })
        
        forecastViewModel.forecastModel.forecastInfo.subscribe({ data in
          
            if data.element??.cod == "200" {
                if let forecast = data.element??.list, !forecast.isEmpty {
                    self.forecastList = forecast
                    if let notSafeForecast = data.element, let forecastResponse = notSafeForecast {
                        self.populateTodayForecast(forecast: forecastResponse)
                       
                    }
                }
            }
        }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        setupLocation()
        setupStyle()
    }
    
    func setupLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func populateTodayForecast(forecast: ForecastResponse) {
        
        
        let currentWeather = forecast.list?.first
        
        self.cityNameLabel.text = forecast.city?.name
        
        if let currentWeather = currentWeather, let main = currentWeather.main {
            self.forecastTempLabel.text = "\(Int((main.temp ?? 0.0).rounded()))°C"
            self.forecastMinLabel.text = "\(Int((main.temp_min ?? 0.0).rounded()))°C"
            self.forecastMaxLabel.text = "\(Int((main.temp_max ?? 0.0).rounded()))°C"
            self.forecastFeelsLabel.text = "\(Int((main.feels_like ?? 0.0).rounded()))°C"
            
            
            if let weather = currentWeather.weather?.first {
                self.forecastInfoLabel.text = weather.main
                if let icon = weather.icon, let urlImg = URL(string:  "https://openweathermap.org/img/wn/\(icon)@2x.png") {
                    self.forecastImageView.kf.setImage(with: urlImg)
                }
            }
            
            self.humidityLabel.text = "\(main.humidity ?? 0)%"
            self.pressureLabel.text = "\(main.pressure ?? 0)hPa"
            self.windLabel.text = "\(Int(((currentWeather.wind?.speed ?? 0) * 3.6).rounded()))km/h"
            self.precipitationLabel.text = "\(currentWeather.rain?.rainInterval ?? 0.0)mm"
        }
        
        self.sunriseLabel.text = "\(forecast.city?.sunrise?.unixToDate().get(.hour) ?? ""):\(forecast.city?.sunrise?.unixToDate().get(.minute) ?? "")"
        self.sunsetLabel.text = "\(forecast.city?.sunset?.unixToDate().get(.hour) ?? ""):\(forecast.city?.sunset?.unixToDate().get(.minute) ?? "")"
        
    }
    
    func setupStyle() {
        self.forecastImageView.layer.cornerRadius = self.forecastImageView.bounds.height / 2
        self.bottomContainerView.layer.cornerRadius = 20
    }


}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case . authorizedAlways, .authorizedWhenInUse:
            //TODO: Load API with current latitude and longitude
            print("AUTORISE \(manager.location?.coordinate)")
            
            if let lat = manager.location?.coordinate.latitude, let long = manager.location?.coordinate.longitude {
            forecastViewModel.dataFetch(lat: String(lat), long: String(long))
            }
            break
        case .denied:
            //TODO: Show in alert
            print("Denied")
            break
        case .notDetermined:
            //TODO: Kust show default state
            print("Not determined")
            break
        default:
            print("We are in default case")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //TOFO: LOAD API with current latitude and longitude
            print("Obtained location after update \(location.coordinate)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //TODO Display some error messeges
        print("ERROROROROR")
    }
}

extension Int {
    func unixToDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}

extension Date {
    func get(_ type: Calendar.Component) -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let t = calendar.component(type, from: self)
        return (t < 10 ? "0\(t)" : t.description)
    }
    
    func getWeekDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let currentDataString: String = dateFormatter.string(from: self)
        return currentDataString
    }
}

extension ViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is ForecastController {
            let forecastController = viewController as! ForecastController
            forecastController.forecastResponse = forecastViewModel.forecastModel.forecastInfo.value
        }
    }
}
