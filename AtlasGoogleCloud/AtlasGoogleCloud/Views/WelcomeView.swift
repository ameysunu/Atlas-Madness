//
//  WelcomeView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 21/06/2023.
//

import SwiftUI
import KeychainAccess

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
    @State private var confirmPwd: String = ""
    @State private var register: Bool = false
    @State private var error: String = ""
    @State var showError = false
    @State private var errorHead = ""
    @State private var navigateToLogin = false
    @Binding var isLoggedIn: Bool
    
    let authToken = generateAuthToken(length: 16)
    
    var body: some View {
        NavigationView{
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
                if register {
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
                    
                    SecureField("Confirm Password",text: $confirmPwd)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 5.0)
                            .stroke(lineWidth: 1.0))
                        .padding(.bottom, 10)
                        .font(.custom("EBGaramond-Regular", size: 20))
                    
                } else {
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
                }
                NavigationLink(destination: DetailView(), isActive: $navigateToLogin){}
                Button(action:{
                    if register{
                        if password == confirmPwd {
                            registerUser(userId: userId, password: password){ outcome in
                                if outcome == "Doesn't exist"{
                                    error = outcome
                                    errorHead = "Error"
                                    showError = true
                                } else {
                                    errorHead = "Success"
                                    error = "Your account has successfully been created!"
                                }
                                
                            }
                        } else {
                            error = "Passwords do not match"
                            errorHead = "Error"
                            showError = true
                        }
                    } else {
                        loginUser(userId: userId, password: password){ outcome in
                            if outcome != "log in" {
                                error = outcome
                                errorHead = "Error"
                                showError = true
                            }
                            navigateToLogin = true
                            saveAuthToken(authToken)
                        }
                    }
                }){
                    if register{
                        Text("Register")
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
                    } else {
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
                    
                    
                }
                if !register {
                    Button(action:{
                        register = true
                    }){
                        Text("Create a new account?")
                            .foregroundColor(.black)
                            .font(.custom("EBGaramond-Regular", size: 25))
                    }
                } else {
                    Button(action:{
                        register = false
                    }){
                        Text("Already have an account?")
                            .foregroundColor(.black)
                            .font(.custom("EBGaramond-Regular", size: 25))
                    }
                }
            }
            .padding()
            .alert(isPresented: $showError){
                Alert(
                    title: Text(errorHead),
                    message: Text(error),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}



//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView(isLoggedIn: false)
//    }
//}
