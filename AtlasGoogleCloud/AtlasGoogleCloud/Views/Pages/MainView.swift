//
//  MainView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 23/06/2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack{
            HStack{
                Text("Home")
                    .font(.custom("EBGaramond-Regular", size: 30))
                Spacer()
            }
            Spacer()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
