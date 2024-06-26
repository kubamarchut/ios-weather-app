//
//  Timeline.swift
//  weather-marchut
//
//  Created by Jakub Marchut on 20/06/2024.
//
import SwiftUI

struct Timeline: View{
    var times: [String]
    let currentTime = Date()
    let timelineWidth = 300.0
    let lineWidth = 6.0
    let indicatorSpacing = 49.0
    let normalHeight = 25.0
    let extendedHeight = 40.0
    
    @State private var heights: [CGFloat] = Array(repeating: 25, count: 5)
    
    @Binding var selectedTime: String
    @Binding var selectedDay: String
    
    var body: some View{
        VStack(alignment: .center, spacing: 10){
            ZStack(alignment: .center){
                Capsule()
                    .fill(Color("accentBlue"))
                    .frame(width: timelineWidth, height: lineWidth)
                HStack(alignment: .center, spacing: indicatorSpacing){
                    ForEach(0..<times.count){index in
                        Button(action: {
                            selectedTime = times[index]
                        }){
                            Capsule()
                                .fill(Color("accentBlue"))
                                .frame(width: lineWidth, height: heights[index])
                                .padding(.horizontal, 0.0)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                if selectedDay == "Dziś"{
                    GeometryReader {geometry in
                        Button(action: {
                            selectedTime = "now"
                        }){
                            Capsule()
                                .fill(Color("accentYellow"))
                                .frame(width: lineWidth, height: extendedHeight)
                                .position(x: calculatePosition(geometry: geometry), y: geometry.size.height / 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(height: extendedHeight)
                }
            }
            .frame(height: extendedHeight)
            HStack(alignment: .center, spacing: 5.0) {
                ForEach(times, id: \.self){ time in
                    VStack {
                        Button(action: {
                            selectedTime = time
                        }) {
                            Text(time)
                                .foregroundColor(time == selectedTime ? Color("accentBlue"): Color("inactiveBlue"))
                                .padding(.horizontal, 2)
                                .frame(width: 50)
                        }
                    }
                }
            }
        }
        .onChange(of: selectedTime){ newTime in
            withAnimation(.easeInOut(duration: 0.3)){
                heights.indices.forEach { index in
                    heights[index] = normalHeight
                }
                if let newTimeIndex = times.firstIndex(of: selectedTime){
                    heights[newTimeIndex] = extendedHeight
                }
            }
        }
    }
    
    func fractionOfDay() -> Double{
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: currentTime)
        
        let elapsedTime = currentTime.timeIntervalSince(startOfDay)
        
        return elapsedTime/86400
    }
    func calculatePosition(geometry: GeometryProxy) -> CGFloat {
        let fractionOfTheDay = fractionOfDay()
        let mainTimelineWidth = CGFloat(times.count - 1) * (indicatorSpacing + lineWidth)
        let secondaryTimelineWidth = timelineWidth - mainTimelineWidth
        var firstProgress = 0.0
        var secondProgress = 0.0
        
        if fractionOfTheDay > 0.75{
            secondProgress = fractionOfTheDay - 0.5
            firstProgress = 0.5
        }
        else{
            firstProgress = fractionOfTheDay - 0.25
            secondProgress = 0.25
        }
        let offset = (mainTimelineWidth * firstProgress + secondaryTimelineWidth * secondProgress) * 2
        return (geometry.size.width - timelineWidth) / 2 + offset
    }
}


struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let times = ["6:00", "9:00", "12:00", "15:00", "18:00"]
        Timeline(times: times, selectedTime: .constant("now"), selectedDay: .constant("Wczoraj"))
        Timeline(times: times, selectedTime: .constant("now"), selectedDay: .constant("Dziś"))
    }
}

