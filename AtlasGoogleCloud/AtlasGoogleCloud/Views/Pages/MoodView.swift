//
//  MoodView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 23/06/2023.
//

import SwiftUI

struct MoodView: View {
    var body: some View {
        VStack{
            HStack{
                Text("Moods")
                    .font(.custom("EBGaramond-Regular", size: 30))
                Spacer()
            }
            Spacer()
        }
    }
}

struct MoodView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView()
    }
}
