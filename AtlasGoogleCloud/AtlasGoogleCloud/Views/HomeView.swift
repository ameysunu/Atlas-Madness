//
//  HomeView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 23/06/2023.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            ScrollView{
                MainView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            MoodView()
                .tabItem {
                    Label("Mood", systemImage: "lasso.and.sparkles")
                }
            
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "text.bubble")
                }
            NavigationView {
                SupportView()
            }
                .tabItem {
                    Label("Support Groups", systemImage: "shared.with.you")
                }
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
