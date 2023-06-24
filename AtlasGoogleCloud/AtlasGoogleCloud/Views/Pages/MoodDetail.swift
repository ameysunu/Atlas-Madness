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
    
    var formattedSleepQuality: String {
        guard let ratingValue = Double(sleepQuality) else {
            return "Invalid Rating"
        }
        return String(format: "%.1f", ratingValue)
    }
    
    var formattedEnergyLevel: String {
        guard let ratingValue = Double(energyLevel) else {
            return "Invalid Rating"
        }
        return String(format: "%.1f", ratingValue)
    }
    
    var formattedAppetiteLevel: String {
        guard let ratingValue = Double(appetite) else {
            return "Invalid Rating"
        }
        return String(format: "%.1f", ratingValue)
    }
    
    var appetiteText: String {
        let doubleAppetite = Double(appetite)
        if doubleAppetite! > 9 {
            return "Your appetite is excellent! Enjoy your meal"
        } else if doubleAppetite! > 8 {
            return "Your appetite is good. Have a satisfying meal."
        } else if doubleAppetite! > 6 {
            return "Your appetite is moderate. Enjoy your food in moderation."
        } else if doubleAppetite! > 4 {
            return "Your appetite is low. Consider having a light meal."
        } else {
            return "You have no appetite at the moment. Listen to your body's needs."
        }
    }
    
    var body: some View {
        ScrollView{
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
                
                HStack{
                    Rectangle()
                        .cornerRadius(5)
                        .offset(x: 4, y: 4)
                        .frame(height: 100)
                        .overlay(
                            Rectangle()
                                .stroke(.black, lineWidth: 5)
                                .background(.orange)
                                .cornerRadius(5)
                                .overlay(VStack{
                                    Text("Energy Level")
                                        .font(.custom("EBGaramond-Regular", size: 15))
                                    Text(formattedEnergyLevel)
                                        .font(.custom("EBGaramond-Regular", size: 40))
                                })
                        )
                    Rectangle()
                        .cornerRadius(5)
                        .offset(x: 4, y: 4)
                        .frame(height: 100)
                        .overlay(
                            Rectangle()
                                .stroke(.black, lineWidth: 5)
                                .background(.blue)
                                .cornerRadius(5)
                                .overlay(VStack{
                                    Text("Sleep Quality")
                                        .font(.custom("EBGaramond-Regular", size: 15))
                                    Text(formattedSleepQuality)
                                        .font(.custom("EBGaramond-Regular", size: 40))
                                }
                                        )
                        )
                }
                .padding(.top, 10)
                
                Rectangle()
                    .cornerRadius(5)
                    .offset(x: 4, y: 4)
                    .frame(height: 150)
                    .overlay(
                        Rectangle()
                            .stroke(.black, lineWidth: 5)
                            .background(.indigo)
                            .cornerRadius(5)
                            .overlay(
                                VStack{
                                    Text("Your appetite level was \(formattedAppetiteLevel)")
                                        .font(.custom("EBGaramond-Regular", size: 25))
                                    Text(appetiteText)
                                        .font(.custom("EBGaramond-Regular", size: 18))
                                        .padding(.top, 2.5)
                                        .padding(10)
                                }
                            )
                    )
                    .padding(.top, 10)
                                
                Text("Triggers and Context")
                    .font(.custom("EBGaramond-Regular", size: 30))
                    .padding(.top, 10)
                
                Text("Your mood generation context was \(context), and were triggered by the factor(s) \(trigger)")
                    .font(.custom("EBGaramond-Regular", size: 20))
                    .padding(.top, 2.5)
                Rectangle()
                    .cornerRadius(5)
                    .offset(x: 4, y: 4)
                    .frame(height: 150)
                    .overlay(
                        Rectangle()
                            .stroke(.black, lineWidth: 5)
                            .background(.white)
                            .cornerRadius(5)
                            .overlay(
                                VStack(alignment: .leading){
                                    ScrollView{
                                        Text(notes)
                                            .font(.custom("EBGaramond-Regular", size: 18))
                                            .padding(.top, 2.5)
                                            .padding(10)
                                    }
                                }
                            )
                    )
                    .padding(.top, 10)
                Spacer()
                Text("Mood was created at: \(timestamp)")
                    .font(.custom("EBGaramond-Regular", size: 20))
            }
            .padding()
        }
    }
}

struct MoodDetail_Previews: PreviewProvider {
    static var previews: some View {
        MoodDetail(appetite: "SSS", context: "Sdsd", energyLevel: "sdsds", mood: "SDsdsd", notes: "DSdsdsd", rating: "SDsdw", sleepQuality: "dwdss", trigger: "dssds", timestamp: "SDsdsd")
    }
}
