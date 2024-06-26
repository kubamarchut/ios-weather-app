//
//  WeatherAPI.swift
//  weather-marchut
//
//  Created by Jakub Marchut on 17/06/2024.
//

import SwiftUI
import Combine

class WeatherAPI: ObservableObject{
    @Published var weatherInformation: WeatherData?
    @Published var displayedWeather: DisplayedWeather
    @Published var currentTemperature = "--°C"
    
    init() {
        self.displayedWeather = DisplayedWeather(temp: nil, weatherCode: nil, humidity: nil, visibility: nil, windSpeed: nil, uvIndex: nil)
    }
    
    func retrieveData(for latitude: Double, longitude: Double){
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=apparent_temperature,weather_code,relative_humidity_2m,visibility,wind_speed_10m,uv_index&hourly=apparent_temperature,weather_code,relative_humidity_2m,visibility,wind_speed_10m,uv_index&past_days=1&forecast_days=2&timezone=auto"
        
        guard let url = URL(string: urlString) else {
            print("invaild API endpoint")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        self.weatherInformation = weatherData
                        
                        self.displayedWeather = DisplayedWeather(temp: weatherData.current.apparentTemperature, weatherCode: weatherData.current.weatherCode, humidity: weatherData.current.humidity, visibility: weatherData.current.visibility, windSpeed: weatherData.current.windSpeed, uvIndex: weatherData.current.uvIndex)
                    }
                }
                catch{
                    print("error while receiving data: \(error)")
                }
            }
        }.resume()
    }
    func updateData(for day: String, at time: String){
        let index: Int
        
        switch day {
        case "Wczoraj":
            index = 0
        case "Dziś":
            index = 24
        case "Jutro":
            index = 48
        default:
            print("invalid day")
            return
        }
        
        if time.contains(":"){
            let timeSeparated = time.split(separator: ":")
            
            if timeSeparated.count == 2, let hour = Int(timeSeparated[0]){
                let timeIndex = index + hour
                
                self.displayedWeather = DisplayedWeather(temp: self.weatherInformation?.hourly.apparentTemperature[timeIndex], weatherCode: self.weatherInformation?.hourly.weatherCode[timeIndex], humidity: self.weatherInformation?.hourly.humidity[timeIndex], visibility: self.weatherInformation?.hourly.visibility[timeIndex], windSpeed: self.weatherInformation?.hourly.windSpeed[timeIndex], uvIndex: self.weatherInformation?.hourly.uvIndex[timeIndex])
            }
        }
        else {
            self.displayedWeather = DisplayedWeather(temp: self.weatherInformation?.current.apparentTemperature, weatherCode: self.weatherInformation?.current.weatherCode, humidity: self.weatherInformation?.current.humidity, visibility: self.weatherInformation?.current.visibility, windSpeed: self.weatherInformation?.current.windSpeed, uvIndex: self.weatherInformation?.current.uvIndex)
        }
    }
}
