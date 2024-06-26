//
//  weatherCardView.swift
//  weather-marchut
//
//  Created by Jakub Marchut on 17/06/2024.
//

import SwiftUI

struct WeatherCard: View{
    var city: String
    var weatherDesc: String
    var weatherIcon: String
    var temperature: String
    var imageName: String
    var additionalInfo: [(String, String)]
    @Binding var selectedTime: String
    @Binding var selectedDay: String
    
    let times = ["6:00", "9:00", "12:00", "15:00", "18:00"]
    let days = ["Wczoraj", "Dziś", "Jutro"]
    
    @State private var currentWeatherIcon: String
    @State private var previousWeatherIcon: String
    @State private var iconOpacity: Double = 1.0
    
    init(city: String, weatherDesc: String, weatherIcon: String, temperature: String, imageName: String, additionalInfo: [(String, String)] ,selectedTime: Binding<String>, selectedDay: Binding<String>) {
        self.city = city
        self.weatherDesc = weatherDesc
        self.weatherIcon = weatherIcon
        self.temperature = temperature
        self.imageName = imageName
        self.additionalInfo = additionalInfo
        self._selectedTime = selectedTime
        self._selectedDay = selectedDay
        self._currentWeatherIcon = State(initialValue: weatherIcon)
        self._previousWeatherIcon = State(initialValue: weatherIcon)
    }
    
    var body: some View{
        ZStack{
            GeometryReader { geometry in
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height * 2/3, alignment: .top)
                    .clipped()
            }
            
            VStack(spacing: 5){
                Spacer()
                ScrollView{
                HStack(alignment: .top){
                    VStack(alignment: .leading){
                        Text(city)
                            .foregroundColor(Color("accentBlue"))
                            .font(.custom("Quicksand-Medium", size:36))
                            .id(city)
                            .animation(.easeInOut)
                        Text(weatherDesc)
                            .foregroundColor(Color("accentBlue"))
                            .font(.custom("Quicksand-Medium", size:18))
                            .id(weatherDesc)
                            .animation(.easeInOut)
                        Text(temperature)
                            .foregroundColor(Color("accentBlue"))
                            .font(.custom("Quicksand-Medium", size:36))
                            .id(temperature)
                            .animation(.easeInOut)
                    }
                    Spacer()
                    ZStack {
                        Image(previousWeatherIcon)
                            .opacity(1.0 - iconOpacity)
                        Image(currentWeatherIcon)
                            .opacity(iconOpacity)
                    }
                }
                Timeline(times: times, selectedTime: $selectedTime, selectedDay: $selectedDay)
                Picker(selection: $selectedDay, label: Text("")){
                    ForEach(days, id: \.self) {day in
                        Text(day).tag(day)
                            .foregroundColor(Color("accentBlue"))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top)
                AdditionalInfo(additionalInfo: additionalInfo)
                }
            .frame(height: 275.0)
            }
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemBackground), Color(UIColor.systemBackground).opacity(0.0)]), startPoint: UnitPoint(x: 0.5, y: 2/3), endPoint: .top))
        }
        .onChange(of: weatherIcon) { newWeatherIcon in
            previousWeatherIcon = newWeatherIcon
            withAnimation(.easeInOut(duration: 0.5)) {
                iconOpacity = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                previousWeatherIcon = currentWeatherIcon
                currentWeatherIcon = newWeatherIcon
                iconOpacity = 1.0
            }
            }
    }
}

struct WeatherCardView_Previews: PreviewProvider {
    static var previews: some View {
        let additionalInfo = [
            ("20 km/h", "wind"),
            ("64%", "drop.fill"),
            ("7.5", "sun.max.fill"),
            ("24000 m", "eye.fill")
        ]
        WeatherCard(city: "Warszawa", weatherDesc: "bezchmurnie", weatherIcon: "clear-sky", temperature: "20.5°C", imageName: "clear-sky-bg", additionalInfo: additionalInfo, selectedTime: .constant("12:00"), selectedDay: .constant("Dziś"))
    }
}
