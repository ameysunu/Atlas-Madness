//
//  SettingsView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 27/06/2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var logoutText = "Logout"
    @State private var backToLogin = false
 
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Settings")
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
                            .background(.red)
                            .cornerRadius(5)
                            .overlay(
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(logoutText)
                                            .font(.custom("EBGaramond-Regular", size: 25))
                                            .foregroundColor(.black)
                                    }
                                    Spacer()
                                    Image(systemName: "powersleep")
                                        .foregroundColor(.black)
                                }
                                .onTapGesture {
                                    logoutText = "Logging out..."
                                    clearAuthToken()
                                    dismiss()
                                }
                                .padding()
                            )
                    )
                    .padding()
                Spacer()
            }
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
