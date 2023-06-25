//
//  MainView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 23/06/2023.
//

import SwiftUI

struct MainView: View {
    
    @State var avgEnergyLevel: Double = 0.0
    @State var avgSleepLevel: Double = 0.0
    @State var averageRating: Double = 0.0
    @State var moodRange: String = ""
    @State var isLoading: Bool = true
    @State var isTimeout: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Text("Home")
                    .font(.custom("EBGaramond-Regular", size: 30))
                Spacer()
            }
            if isLoading {
                if isTimeout{
                    Text("There is no enough data to create your dashboard or there is an issue with internet connectivity.")
                        .font(.custom("EBGaramond-Regular", size: 20))
                } else {
                    HStack{
                        Text("Loading your personalized dashboard")
                            .font(.custom("EBGaramond-Regular", size: 20))
                        ProgressView()
                            .padding(.leading, 5)
                    }
                }
            } else {
                Rectangle()
                    .cornerRadius(5)
                    .offset(x: 4, y: 4)
                    .frame(height: 100)
                    .overlay(
                        Rectangle()
                            .stroke(.black, lineWidth: 5)
                            .background(.white)
                            .cornerRadius(5)
                            .overlay(
                                HStack{
                                    VStack(alignment: .leading){
                                        Text("Your general mood has been:")
                                            .font(.custom("EBGaramond-Regular", size: 15))
                                            .padding(.top, 5)
                                        Text("\(moodRange)!")
                                            .font(.custom("EBGaramond-Regular", size: 30))
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                    .padding()
                            )
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
                                .background(returnBoxColor(params: avgEnergyLevel))
                                .cornerRadius(5)
                                .overlay(
                                    HStack{
                                        VStack(alignment: .leading){
                                            Text("Average Energy Level")
                                                .font(.custom("EBGaramond-Regular", size: 15))
                                                .padding(.top, 5)
                                            Text("\(avgEnergyLevel, specifier: "%.1f")")
                                                .font(.custom("EBGaramond-Regular", size: 30))
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                        .padding()
                                    
                                    
                                    
                                )
                        )
                    Rectangle()
                        .cornerRadius(5)
                        .offset(x: 4, y: 4)
                        .frame(height: 100)
                        .overlay(
                            Rectangle()
                                .stroke(.black, lineWidth: 5)
                                .background(returnBoxColor(params: avgSleepLevel))
                                .cornerRadius(5)
                                .overlay(
                                    HStack{
                                        VStack(alignment: .leading){
                                            Text("Average Sleep Level")
                                                .font(.custom("EBGaramond-Regular", size: 15))
                                                .padding(.top, 5)
                                            Text("\(avgSleepLevel, specifier: "%.1f")")
                                                .font(.custom("EBGaramond-Regular", size: 30))
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                        .padding()
                                    
                                    
                                )
                        )
                    
                }
            }
            
            Spacer()
        }
        .onAppear{
            isTimeout = false
            let timeoutDuration: TimeInterval = 10
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timeoutDuration) {
                // Timeout reached, show error message
                if isLoading {
                    isTimeout = true
                    isLoading = true
                }
            }
            
            getAverageEnergySleep(){ rating, energy, sleep in
                averageRating = rating
                avgEnergyLevel = energy
                avgSleepLevel = sleep
                getAverageMood(){ result in
                    moodRange = result
                    isLoading = false
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
