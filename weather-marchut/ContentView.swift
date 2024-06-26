//
//  ContentView.swift
//  weather-marchut
//
//  Created by Jakub Marchut on 17/06/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject private var weatherAPI = WeatherAPI()
    
    @State private var selectedTime = "now"
    @State private var selectedDay = "Dziś"
    @State private var selectedCity = "Warszawa"
    @State private var isLoadingLocation: Bool = false
    @State private var isCustomLocation: Bool = false
    
    @State var customLocationLabel = "Zlokalizuj mnie"
    @State var customLocationTag = "custom-location"
    
    init() {
       UISegmentedControl.appearance().backgroundColor = UIColor(Color("inactiveBlue")).withAlphaComponent(0.15)
       UISegmentedControl.appearance().setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
       UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("accentBlue"))
       UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    var body: some View {
        VStack{
            WeatherCard(city: selectedCity, weatherDesc: weatherAPI.displayedWeather.weatherDescription, weatherIcon: weatherAPI.displayedWeather.weatherIcon, temperature: weatherAPI.displayedWeather.temperatureString, imageName: weatherAPI.displayedWeather.weatherBg, additionalInfo: [(weatherAPI.displayedWeather.windSpeedString, "wind"), (weatherAPI.displayedWeather.humidityString, "drop.fill"), (weatherAPI.displayedWeather.uvIndexString, "sun.max.fill"), (weatherAPI.displayedWeather.visibilityString, "eye.fill")], selectedTime: $selectedTime, selectedDay: $selectedDay)
            
            Picker("Wybierz miasto", selection: $selectedCity){
                Text(customLocationLabel).tag(customLocationTag)
                Text("Warszawa").tag("Warszawa")
                Text("Bolonia").tag("Bolonia")
                Text("Cordoba").tag("Cordoba")
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedCity){ newCity in
                selectedTime = "now"
                selectedDay = "Dziś"
                switch newCity {
                case "custom-location":
                    isLoadingLocation = true
                    locationManager.requestLocation()
                case "Warszawa":
                    weatherAPI.retrieveData(for: 52.25, longitude: 21)
                    isCustomLocation = false
                    isLoadingLocation = false
                case "Bolonia":
                    weatherAPI.retrieveData(for: 44.49, longitude: 11.33)
                    isCustomLocation = false
                    isLoadingLocation = false
                case "Cordoba":
                    weatherAPI.retrieveData(for: -31.42, longitude: -64.18)
                    isCustomLocation = false
                    isLoadingLocation = false
                case locationManager.cityName:
                    if let location = locationManager.location{
                        weatherAPI.retrieveData(for: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    }
                default:
                    break
                }
            }
            .onChange(of: locationManager.isCityNameUpdated){ isCityNameUpdated in
                if isCityNameUpdated {
                    if let location = locationManager.location {
                        weatherAPI.retrieveData(for: location.coordinate.latitude, longitude: location.coordinate.longitude)
                        print(locationManager.cityName)
                        selectedCity = locationManager.cityName
                        customLocationLabel = locationManager.cityName
                        customLocationTag = locationManager.cityName
                    }
                    
                }
            }
        }
        .onAppear{
            weatherAPI.retrieveData(for: 52.25, longitude: 21)
        }
        .onChange(of: selectedTime){ newTime in
            weatherAPI.updateData(for: selectedDay, at: newTime)
        }
        .onChange(of: selectedDay){ newDay in
            if selectedTime == "now"{
                selectedTime = "6:00"
            }
            weatherAPI.updateData(for: newDay, at: selectedTime)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
