//
//  MainView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 23/06/2023.
//

import SwiftUI

struct MainView: View {
    
    @State var avgEnergyLevel: String = "5.0"
    @State var avgSleepLevel: String = "0.0"
    
    var body: some View {
        VStack{
            HStack{
                Text("Home")
                    .font(.custom("EBGaramond-Regular", size: 30))
                Spacer()
            }
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
                                    Text("Happy!")
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
                                        Text("5.0")
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
                                        Text("0.0")
                                            .font(.custom("EBGaramond-Regular", size: 30))
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                    .padding()
                                
                                
                            )
                    )
                
            }
            
            Spacer()
        }
        .onAppear{
            getAverageEnergySleep(){ rating, energy, sleep in
                print("energy: \(energy)")
                print("rating: \(rating)")
                print("sleep: \(sleep)")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
