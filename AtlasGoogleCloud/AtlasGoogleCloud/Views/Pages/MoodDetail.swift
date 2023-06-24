//
//  MoodDetail.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 24/06/2023.
//

import SwiftUI

struct MoodDetail: View {
    
    @State var appetite: String
    @State var context: String
    @State var energyLevel: String
    @State var mood: String
    @State var notes: String
    @State var rating: String
    @State var sleepQuality: String
    @State var trigger: String
    @State var timestamp: String
    
    var formattedRating: String {
        guard let ratingValue = Double(rating) else {
            return "Invalid Rating"
        }
        return String(format: "%.1f", ratingValue)
    }
    
    var ratingColor: Color {
        let doubleRating = Double(formattedRating)
        if doubleRating! > 7 {
            return Color.green
        } else if doubleRating! >= 4 {
            return Color.orange
        } else {
            return Color.red
        }
    }
    
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(mood)
                    .font(.custom("EBGaramond-Regular", size: 35))
                Spacer()
            }
            Rectangle()
                .cornerRadius(5)
                .offset(x: 4, y: 4)
                .frame(height: 100)
                .overlay(
                    Rectangle()
                        .stroke(.black, lineWidth: 5)
                        .background(ratingColor)
                        .cornerRadius(5)
                        .overlay(Text("You rated \(formattedRating) out of 10")
                            .font(.custom("EBGaramond-Regular", size: 25)))
                )
                .padding(.top, 5)
            Spacer()
        }
        .padding()
    }
}

struct MoodDetail_Previews: PreviewProvider {
    static var previews: some View {
        MoodDetail(appetite: "SSS", context: "Sdsd", energyLevel: "sdsds", mood: "SDsdsd", notes: "DSdsdsd", rating: "SDsdw", sleepQuality: "dwdss", trigger: "dssds", timestamp: "SDsdsd")
    }
}
