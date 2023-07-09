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
        VStack{
            HStack{
                Text("Activities")
                    .font(.custom("EBGaramond-Regular", size: 35))
                    .padding()
                Spacer()
                Button(action:{}){
                    Image(systemName: "plus")
                }
            }
            .padding()
            
            ScrollView {
                ForEach(activities, id: \._id) { activityData in
                    ForEach(activityData.activity, id: \.name) { activity in
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
                                        VStack(alignment: .leading) {
                                            Text(activity.name)
                                                .font(.custom("EBGaramond-Regular", size: 25))
                                            Text(activity.description)
                                                .font(.custom("EBGaramond-Regular", size: 20))
                                            HStack{
                                                Spacer()
                                                Text("By: \(activity.userId)")
                                                    .font(.custom("EBGaramond-Regular", size: 20))
                                            }
                                        }
                                            .padding()
                                    )
                            )
                    }
                }
            }
            .padding()
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
}


