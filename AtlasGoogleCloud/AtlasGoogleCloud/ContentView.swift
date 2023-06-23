//
//  ContentView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 21/06/2023.
//

import SwiftUI
import KeychainAccess

struct ContentView: View {
    
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        Group{
            if isLoggedIn {
                DetailView()
            } else {
                WelcomeView(isLoggedIn: $isLoggedIn)
            }
        }
        .onAppear{
            checkLoginState()
        }
    }
    
    private func checkLoginState() {
        if let _ = getAuthToken() {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
