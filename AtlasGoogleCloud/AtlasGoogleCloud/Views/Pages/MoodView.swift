//
//  MoodView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 23/06/2023.
//

import SwiftUI

struct MoodView: View {
    
    @State var createMood: Bool = false
    @State var jsonData = ""
    @State private var moodData: [Mood] = []
    
    var body: some View {
        VStack{
            HStack{
                Text("Moods")
                    .font(.custom("EBGaramond-Regular", size: 30))
                Spacer()
            }
            if !moodData.isEmpty {
                ForEach(moodData) { mood in
                    Text(mood.mood)
                        .foregroundColor(.red)
                    // Add a debug statement to print the mood property
                    //print("Mood: \(mood.mood)")
                    Button(action:{
                        print(mood.mood)
                    }){
                        Text(mood.energyLevel)
                    }
                }
            } else {
                Text("Loading JSON data...")
            }

            Spacer()
            Button(action:{
                createMood.toggle()
            }){
                Text("Add")
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
        .sheet(isPresented: $createMood){
            CreateMoodView()
        }
        .onAppear {
            getCurrentUserMoods(userid: currentUserId!){ result, error in
                
                if let error = error {
                    print(error)
                }
                
                if let result = result {
                    print(result)
                    self.moodData = result
                } else {
                    print("mood data is null")
                }
            }
        }
    }
}

struct MoodView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView()
    }
}

struct CreateMoodView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var mood: String = "Happy"
    let moodOptions = [
        "Happy",
        "Content",
        "Excited",
        "Joyful",
        "Peaceful",
        "Calm",
        "Relaxed",
        "Grateful",
        "Hopeful",
        "Optimistic",
        "Inspired",
        "Motivated",
        "Energetic",
        "Focused",
        "Productive",
        "Neutral",
        "Bored",
        "Indifferent",
        "Stressed",
        "Anxious",
        "Worried",
        "Overwhelmed",
        "Sad",
        "Lonely",
        "Depressed",
        "Angry",
        "Frustrated",
        "Irritated",
        "Overjoyed",
        "Nostalgic"
    ]
    @State var moodSlider: Double = 0
    @State var notes: String = ""
    @State var context: String = ""
    @State var trigger: String = ""
    @State var secondScreen: Bool = false
    @State var sleepQuality: Double = 0
    @State var appetite: Double = 0
    @State var energyLevel: Double = 0
    
    func getCurrentTimeStamp() -> String{
        let currentDateTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDateTime)
        
        return dateString
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                if secondScreen {
                    HStack{
                        Text("Select the following applicable")
                            .font(.custom("EBGaramond-Regular", size: 25))
                        Spacer()
                    }
                    .padding(.bottom)
                    Text("Sleep Quality: \(sleepQuality, specifier: "%.1f")")
                        .font(.custom("EBGaramond-Regular", size: 20))
                    Slider(value: $sleepQuality, in: 0...10)
                    
                    Text("Appetite: \(appetite, specifier: "%.1f")")
                        .font(.custom("EBGaramond-Regular", size: 20))
                    Slider(value: $appetite, in: 0...10)
                    
                    Text("Energy Level: \(energyLevel, specifier: "%.1f")")
                        .font(.custom("EBGaramond-Regular", size: 20))
                    Slider(value: $energyLevel, in: 0...10)
                    
                    
                } else {
                    HStack{
                        Text("How are you feeling right now?")
                            .font(.custom("EBGaramond-Regular", size: 20))
                        Picker("Your mood", selection: $mood) {
                            ForEach(moodOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        Spacer()
                    }
                    Text("Rate your current mood: \(moodSlider, specifier: "%.1f")")
                        .font(.custom("EBGaramond-Regular", size: 20))
                    Slider(value: $moodSlider, in: 0...10)
                    //Capture date and time
                    Text("Contextual information that influenced your current mood")
                        .font(.custom("EBGaramond-Regular", size: 20))
                    TextField("Context",text: $context)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 5.0)
                            .stroke(lineWidth: 1.0))
                        .padding(.bottom, 10)
                        .font(.custom("EBGaramond-Regular", size: 20))
                    
                    Text("Trigger which provoked your mood")
                        .font(.custom("EBGaramond-Regular", size: 20))
                    TextField("Trigger",text: $trigger)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 5.0)
                            .stroke(lineWidth: 1.0))
                        .padding(.bottom, 10)
                        .font(.custom("EBGaramond-Regular", size: 20))
                    
                    Text("Additional Notes")
                        .font(.custom("EBGaramond-Regular", size: 20))
                    
                    TextEditor(text: $notes)
                        .overlay(RoundedRectangle(cornerRadius: 5.0)
                            .stroke(lineWidth: 1.0))
                        .frame(height: 200)
                        .background(Color(.systemGray6))
                        .padding(.bottom, 10)
                }
                Button(action:{
                    if secondScreen {
                        addMoodData(userid: currentUserId!, mood: mood, rating: moodSlider, notes: notes, context: context, trigger: trigger, sleepQuality: sleepQuality, appetite: appetite, energyLevel: energyLevel, timeStamp: getCurrentTimeStamp()){ result in
                            print(result);
                            dismiss()
                        }
                    } else {
                        secondScreen = true
                    }
                }) {
                    if secondScreen {
                        Text("Submit")
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
                    } else {
                        Text("Next")
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
}
