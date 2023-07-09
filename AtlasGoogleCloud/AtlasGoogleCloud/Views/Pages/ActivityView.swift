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
        VStack {
            ScrollView {
                ForEach(activities, id: \._id) { activityData in
                    ForEach(activityData.activity, id: \.name) { activity in
                        VStack(alignment: .leading) {
                            Text("Name: \(activity.name)")
                                .font(.headline)
                            Text("Description: \(activity.description)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
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


