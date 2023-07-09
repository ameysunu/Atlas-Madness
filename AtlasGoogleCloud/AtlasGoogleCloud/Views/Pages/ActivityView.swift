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
    @State var addActivity: Bool = false

    var body: some View {
        VStack{
            HStack{
                Text("Activities")
                    .font(.custom("EBGaramond-Regular", size: 35))
                    .padding()
                Spacer()
                Button(action:{
                    addActivity = true
                }){
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
        .sheet(isPresented: $addActivity) {
            CreateActivity()
        }
    }
}


struct CreateActivity: View {
    
    var userId: String = getLoginToken()!
    @State var name: String = ""
    @State var description: String = ""
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                
                Text("Add an activity")
                    .font(.custom("EBGaramond-Regular", size: 35))
                    .padding(.bottom, 10)
                
                TextField("Name",text: $name)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5.0)
                        .stroke(lineWidth: 1.0))
                    .padding(.bottom, 10)
                    .font(.custom("EBGaramond-Regular", size: 20))
                
                Text("Description")
                    .font(.custom("EBGaramond-Regular", size: 20))
                
                TextEditor(text: $description)
                    .overlay(RoundedRectangle(cornerRadius: 5.0)
                        .stroke(lineWidth: 1.0))
                    .frame(height: 200)
                    .background(Color(.systemGray6))
                    .padding(.bottom, 10)
                Spacer()
                Button(action:{}){
                    Text("Add")
                        .font(.custom("EBGaramond-Regular", size: 20))
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
        }
        .padding()
    }
}
