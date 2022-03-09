//
//  ForecastController.swift
//  My Honest Weather
//
//  Created by Gleb Gribov on 05.03.2022.
//

import UIKit

class ForecastController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
   
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var forecastResponse: ForecastResponse?
    var newForecastArray = [Int: [Forecast]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Result of forecast response \(forecastResponse)")
        cityNameLabel.text = forecastResponse?.city?.name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return getNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourlyCell") as! HourlyTableViewCell
        if let currentForecast = newForecastArray[indexPath.section + 1] {
            cell.configure(forecast: currentForecast[indexPath.row + 1])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let newForecast = newForecastArray[section + 1] {
            return newForecast.count - 1
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 45))
        let weekDayLabel = UILabel(frame: CGRect(x: 24, y: 0, width: tableView.bounds.width, height: 20))
        
        view.backgroundColor = .white
        
        if let currentDate = newForecastArray[section + 1]?.first?.dt?.unixToDate() {
            
            if Date().get(.day) == currentDate.get(.day) {
                weekDayLabel.text = "Today"
            }else if (Int(Date().get(.day)) ?? 0)+1 == Int(currentDate.get(.day)) {
                weekDayLabel.text = "Tomorrow"
            }else {
                weekDayLabel.text = currentDate.getWeekDay()
            }
        }
        
        weekDayLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        view.addSubview(weekDayLabel)
        return view
    }
   


}

extension ForecastController {
    func getNumberOfSection() -> Int {
        newForecastArray.removeAll()
        var numberOfSection = 0
        var currentDate: Date?
        var previousDate: Date?
        
        if let forecastResponse = forecastResponse {
            for forecast in forecastResponse.list! {
                currentDate = (forecast.dt?.unixToDate())!
                if previousDate?.get(.day) != currentDate?.get(.day) {
                    numberOfSection += 1
                    previousDate = currentDate
                }
                newForecastArray[numberOfSection, default: [forecast]].append(forecast)
        }
        
            
        }
        return numberOfSection
    }
}
