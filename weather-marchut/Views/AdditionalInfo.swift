//
//  AdditionalInfo.swift
//  weather-marchut
//
//  Created by Jakub Marchut on 24/06/2024.
//
import SwiftUI

struct AdditionalInfo: View{
    let additionalInfo: [(String, String)]
    
    var body: some View{
        HStack(alignment: .top, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(additionalInfo.prefix(additionalInfo.count / 2), id: \.0) { info in
                    HStack {
                        Image(systemName: info.1)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("accentBlue"))
                        Text(info.0)
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(additionalInfo.suffix(additionalInfo.count / 2), id: \.0) { info in
                    HStack {
                        Image(systemName: info.1)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("accentBlue"))
                        Text(info.0)
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .padding()
    }
}


struct AdditionalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let additionalInfo = [
            ("20 km/h", "wind"),
            ("64%", "drop.fill"),
            ("7.5", "sun.max.fill"),
            ("24000 m", "eye.fill")
        ]
        AdditionalInfo(additionalInfo: additionalInfo)
    }
}

