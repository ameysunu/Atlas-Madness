//
//  ActivityView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 08/07/2023.
//

import SwiftUI

struct ActivityView: View {
    
    @State var groupId: String
    @State private var activities: [ActivityData] = []
    
    var body: some View {
        Text("Hello, World!")
            .onAppear{
                getGroupActivities(urlString: "http://localhost:8080/activities/\(groupId)") { result in
                    switch result {
                    case .success(let data):
                        self.activities = data
                    case .failure(let error):
                        print(error)
                    }
                }
            }
    }
}

