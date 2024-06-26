//
//  WeatherData.swift
//  weather-marchut
//
//  Created by Jakub Marchut on 17/06/2024.
//

import Foundation

struct WeatherData: Codable{
    let latitude: Double
    let longitude: Double
    let timezone: String
    let current: CurrentWeather
    let hourly: HourlyWeather
}

struct CurrentWeather: Codable{
    let time: String
    let apparentTemperature: Double
    let weatherCode: Int
    let humidity: Int
    let visibility: Double
    let windSpeed: Double
    let uvIndex: Double
    
    
    enum CodingKeys: String, CodingKey{
        case time
        case apparentTemperature = "apparent_temperature"
        case weatherCode = "weather_code"
        case humidity = "relative_humidity_2m"
        case visibility
        case windSpeed = "wind_speed_10m"
        case uvIndex = "uv_index"
    }
}

struct HourlyWeather: Codable{
    let time: [String]
    let apparentTemperature: [Double]
    let weatherCode: [Int]
    let humidity: [Int]
    let visibility: [Double]
    let windSpeed: [Double]
    let uvIndex: [Double]
    
    enum CodingKeys: String, CodingKey{
        case time
        case apparentTemperature = "apparent_temperature"
        case weatherCode = "weather_code"
        case humidity = "relative_humidity_2m"
        case visibility
        case windSpeed = "wind_speed_10m"
        case uvIndex = "uv_index"
    }
}

class DisplayedWeather{
    let temperatureString: String
    let weatherIcon: String
    let weatherBg: String
    let weatherDescription: String
    let humidityString: String
    let visibilityString: String
    let windSpeedString: String
    let uvIndexString: String
    
    init(temp: Double?, weatherCode: Int?, humidity: Int?, visibility: Double?, windSpeed: Double?, uvIndex: Double?){
        temperatureString = "\(temp != nil ? String(temp!) : "--")°C"
        humidityString = "\(humidity != nil ? String(humidity!) : "--")%"
        windSpeedString = "\(windSpeed != nil ? String(windSpeed!) : "--") km/h"
        uvIndexString = "\(uvIndex != nil ? String(uvIndex!) : "--")"
        if let visibility = visibility{
            if visibility > 1000{
                visibilityString = "\(visibility/1000) km"
            }
            else{
                visibilityString = "\(visibility) m"
            }
        }
        else{
            visibilityString = "-- m"
        }
        let description = DisplayedWeather.weatherCodeDescription(for: weatherCode)
        weatherDescription = description.0
        weatherIcon = description.1
        weatherBg = description.2
    }
    private static func weatherCodeDescription(for code: Int?) -> (String, String, String) {
        if let code = code{
            return weatherCodeDescriptions[code] ?? ("Nieznana", "clear-sky", "clear-sky-bg")
        }
        return ("Nieznana", "clear-sky", "clear-sky-bg")
    }
}

let weatherCodeDescriptions: [Int: (String, String, String)] = [
    0: ("Bezchmurnie", "clear-sky", "clear-sky-bg"),
    1: ("Przeważnie bezchmurnie", "clear-sky", "clear-sky-bg"),
    2: ("Częściowe zachmurzenie", "partly-cloudy", "clear-sky-bg"),
    3: ("Pochmurnie", "overcast", "clear-sky-bg"),
    45: ("Mgła", "fog", "fog-bg"),
    48: ("Szadź", "fog", "fog-bg"),
    51: ("Lekka mżawka", "drizzle", "drizzle-bg"),
    53: ("Umiarkowana mżawka", "drizzle", "drizzle-bg"),
    55: ("Gęsta mżawka", "drizzle", "drizzle-bg"),
    56: ("Lekka marznąca mżawka", "drizzle", "drizzle-bg"),
    57: ("Gęsta marznąca mżawka", "drizzle", "drizzle-bg"),
    61: ("Lekki deszcz", "rain", "rain-bg"),
    63: ("Umiarkowany deszcz", "rain", "rain-bg"),
    65: ("Mocny deszcz", "rain-heavy", "rain-bg"),
    66: ("Lekki marznący deszcz", "rain", "rain-bg"),
    67: ("Mocny marznący deszcz", "rain-heavy", "rain-bg"),
    71: ("Lekki opad śniegu", "snow", "snow-bg"),
    73: ("Umiarkowany opad śniegu", "snow", "snow-bg"),
    75: ("Mocny opad śniegu", "snow", "snow-bg"),
    77: ("Śnieg ziarnisty", "snow", "snow-bg"),
    80: ("Lekka przelotna mrzawka", "rain", "rain-bg"),
    81: ("Umiarkowana przelotna mrzawka", "rain", "rain-bg"),
    82: ("Mocna przelotna mrzawka", "rain-heavy", "rain-bg"),
    85: ("Lekka przelotna śnieżyca", "snow", "snow-bg"),
    86: ("Mocna przelotna śnieżyca", "snow", "snow-bg"),
    95: ("Burza", "thunderstorm", "thunderstorm-bg"),
    96: ("Burza z gradem", "thunderstorm", "thunderstorm-bg"),
    99: ("Burza z mocnym gradem", "thunderstorm", "thunderstorm-bg")
]
