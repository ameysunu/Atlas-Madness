//
//  WelcomeView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 21/06/2023.
//

import SwiftUI

struct WelcomeView: View {
    let hour = Calendar.current.component(.hour, from: Date())
    func determineGreeting(hour: Int) -> String {
        switch hour {
        case 0..<12:
            return "Morning"
        case 12..<17:
            return "Afternoon"
        default:
            return "Evening"
        }
    }
    @State private var userId: String = ""
    @State private var password: String = ""
    var body: some View {
        VStack{
            HStack{
                Text("Good")
                    .font(.custom("EBGaramond-Regular", size: 64))
                Spacer()
            }
            HStack{
                Text("\(determineGreeting(hour: hour))!")
                    .font(.custom("EBGaramond-Regular", size: 64))
                Spacer()
            }
            Spacer()
            TextField("User ID",text: $userId)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5.0)
                    .stroke(lineWidth: 1.0))
                .padding(.bottom, 10)
                .font(.custom("EBGaramond-Regular", size: 20))
            
            SecureField("Password",text: $password)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5.0)
                    .stroke(lineWidth: 1.0))
                .padding(.bottom, 10)
                .font(.custom("EBGaramond-Regular", size: 20))
            Button(action:{
                loginUser(userId: userId, password: password)
            }){
                Text("Login")
                    .font(.custom("EBGaramond-Regular", size: 25))
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 0.1)
                        .shadow(color: .black, radius: 10.0))
                    .background(RoundedRectangle(cornerRadius: 10).fill(.black))
                    .padding(.top, 20)
                
            }
            Button(action:{}){
                Text("Create a new account?")
                    .foregroundColor(.black)
                    .font(.custom("EBGaramond-Regular", size: 25))
            }
        }
        .padding()
    }
}



struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
