//
//  HourlyTableViewCell.swift
//  My Honest Weather
//
//  Created by Gleb Gribov on 05.03.2022.
//

import UIKit
import Kingfisher

class HourlyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var forecastImageView: UIImageView!
    @IBOutlet weak var forecastDateLabel: UILabel!
    @IBOutlet weak var forecastInfoLabel: UILabel!
    @IBOutlet weak var forecastTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }
    
    func configure(forecast: Forecast) {
        if let icon = forecast.weather?.first?.icon, let urlImg = URL(string:  "https://openweathermap.org/img/wn/\(icon)@2x.png") {
            self.forecastImageView.kf.setImage(with: urlImg)
        }
        let currentDate = forecast.dt?.unixToDate()
        //22, Friday
        self.forecastDateLabel.text = "\(currentDate?.get(.hour) ?? ""): \(currentDate?.get(.minute) ?? "")"
        self.forecastInfoLabel.text = forecast.weather?.first?.main
        self.forecastTempLabel.text = "\(Int(forecast.main?.temp?.rounded() ?? 0))°C"
    
    }

}
