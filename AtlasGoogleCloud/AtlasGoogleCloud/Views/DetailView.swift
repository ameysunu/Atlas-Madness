//
//  DetailView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 22/06/2023.
//

import SwiftUI

struct DetailView: View {
    @State var username: String = ""
    @State var age: String = ""
    @State var gender: String = "Select"
    let genders = ["Male", "Female", "Others"]
    @State var secondScreen: Bool = false
    @State var thirdScreen: Bool = false
    @State private var selectedTopics: Set<String> = []
    @State private var selectedActivities: [String] = []

    let topics = [
        "Depression Management",
        "Anxiety and Panic Attacks",
        "Mindfulness and Meditation",
        "Stress Reduction Techniques",
        "Sleep Improvement Strategies",
        "Self-Care and Self-Compassion",
        "Emotional Regulation",
        "Coping with Grief and Loss",
        "Building Resilience",
        "Anger Management",
        "Relationship and Communication Skills",
        "Body Image and Self-Esteem",
        "Substance Abuse Recovery",
        "Eating Disorder Support",
        "Post-Traumatic Stress Disorder (PTSD) Recovery",
        "ADHD Management Strategies",
        "Bipolar Disorder Management",
        "OCD (Obsessive-Compulsive Disorder) Support",
        "Social Anxiety Coping Techniques",
        "Phobia Management"
    ]
    
    let activities = [
        "😴 Improve Sleep Quality",
        "😊 Manage Stress",
        "🧖🏻‍♀️ Practice Self-Care",
        "✨ Enhance Emotional Well-being",
        "💞 Foster Healthy Relationships",
        "🧘🏻‍♀️ Cultivate Mindfulness",
        "💪🏻 Boost Physical Activity",
        "🥗 Improve Nutrition",
        "🐕‍🦺 Build Resilience",
        "🗣️ Seek Support"
    ]
    
    var body: some View {
        VStack {
            HStack{
                Text("Welcome! Just a few questions before you get started.")
                    .font(.custom("EBGaramond-Regular", size: 30))
                Spacer()
            }
            if thirdScreen {
                Text("What goals do you intend to achieve?")
                    .font(.custom("EBGaramond-Regular", size: 25))
                    .padding(.top)
                List(activities, id: \.self) { activity in
                    Button(action: {
                        toggleActivitySelection(activity)
                    }) {
                        Text(activity)
                            .padding(10)
                            .foregroundColor(selectedActivities.contains(activity) ? .white : .primary)
                            .background(selectedActivities.contains(activity) ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                }
            } else if secondScreen {
                Text("Select the topics that relates to your mental health")
                    .font(.custom("EBGaramond-Regular", size: 25))
                    .padding(.top)
                List(topics, id: \.self) { item in
                             Toggle(item, isOn: Binding(
                                 get: { selectedTopics.contains(item) },
                                 set: { isSelected in
                                     if isSelected {
                                         selectedTopics.insert(item)
                                     } else {
                                         selectedTopics.remove(item)
                                     }
                                 }
                             ))
                         }
                
                
            } else {
                TextField("Name",text: $username)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5.0)
                        .stroke(lineWidth: 1.0))
                    .padding(.bottom, 10)
                    .font(.custom("EBGaramond-Regular", size: 20))
                
                TextField("Age",text: $age)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5.0)
                        .stroke(lineWidth: 1.0))
                    .padding(.bottom, 10)
                    .font(.custom("EBGaramond-Regular", size: 20))
                
                HStack{
                    Text("Select your gender")
                        .font(.custom("EBGaramond-Regular", size: 20))
                    Picker("Select a paint color", selection: $gender) {
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    Spacer()
                }
            }
            
            Spacer()
            if thirdScreen {
                Button(action: {
                    addUserPreferences(userid: username, age: age, gender: gender, topics: selectedTopics, goals: selectedActivities) { result in
                        print(result)
                    }
                }){
                    Text("Submit")
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
            } else {
                Button(action:{
                    print("Selected items: \(selectedTopics)")
                    print(selectedActivities)
                    if secondScreen == true {
                        thirdScreen = true
                    } else {
                        secondScreen = true
                    }
                }){
                    Text("Next")
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
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
    private func toggleActivitySelection(_ activity: String) {
            if selectedActivities.contains(activity) {
                selectedActivities.removeAll { $0 == activity }
            } else {
                selectedActivities.append(activity)
            }
        }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
