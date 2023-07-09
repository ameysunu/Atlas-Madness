//
//  SupportGroup.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 01/07/2023.
//

import SwiftUI

struct SupportGroup: View {
    let group: Groups?
    @State var isJoined: Bool = false
    @State var chatOpen: Bool = false
    @State var activityOpen: Bool = false
    
    var body: some View {
        VStack{
            ScrollView{
                Rectangle()
                    .cornerRadius(5)
                    .offset(x: 4, y: 4)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Rectangle()
                            .stroke(.black, lineWidth: 5)
                            .background(.orange)
                            .cornerRadius(5)
                            .overlay(
                                Image(systemName: "person.3.fill")
                            )
                    )
                Text(group!.name)
                    .font(.custom("EBGaramond-Regular", size: 25))
                Text(group!.description)
                    .font(.custom("EBGaramond-Regular", size: 18))
                    .foregroundColor(.gray)
                
                HStack{
                    Rectangle()
                        .cornerRadius(5)
                        .offset(x: 4, y: 4)
                        .frame(height: 100)
                        .overlay(
                            Rectangle()
                                .stroke(.black, lineWidth: 5)
                                .background(.white)
                                .cornerRadius(5)
                                .overlay(VStack{
                                    Text("Participants")
                                        .font(.custom("EBGaramond-Regular", size: 15))
                                    Text("\(group!.members.count)")
                                        .font(.custom("EBGaramond-Regular", size: 40))
                                }
                                        )
                        )
                    Rectangle()
                        .cornerRadius(5)
                        .offset(x: 4, y: 4)
                        .frame(height: 100)
                        .overlay(
                            Rectangle()
                                .stroke(.black, lineWidth: 5)
                                .background(.white)
                                .cornerRadius(5)
                                .overlay(VStack{
                                    Text("Moderators")
                                        .font(.custom("EBGaramond-Regular", size: 15))
                                    Text("\(group!.facilitators.count)")
                                        .font(.custom("EBGaramond-Regular", size: 40))
                                }
                                        )
                        )
                    Rectangle()
                        .cornerRadius(5)
                        .offset(x: 4, y: 4)
                        .frame(height: 100)
                        .overlay(
                            Rectangle()
                                .stroke(.black, lineWidth: 5)
                                .background(.white)
                                .cornerRadius(5)
                                .overlay(VStack{
                                    Text("Group ID")
                                        .font(.custom("EBGaramond-Regular", size: 15))
                                    Text("\(group!.groupId)")
                                        .font(.custom("EBGaramond-Regular", size: 20))
                                }
                                        )
                        )
                    
                }
                if isJoined {
                    Rectangle()
                        .cornerRadius(5)
                        .offset(x: 4, y: 4)
                        .frame(height: 50)
                        .overlay(
                            Rectangle()
                                .stroke(.black, lineWidth: 5)
                                .background(.blue)
                                .cornerRadius(5)
                                .overlay(
                                    Text("You are already a member")
                                        .font(.custom("EBGaramond-Regular", size: 20))
                                        .foregroundColor(.white)
                                )
                        )
                } else {
                    Rectangle()
                        .cornerRadius(5)
                        .offset(x: 4, y: 4)
                        .frame(height: 50)
                        .overlay(
                            Rectangle()
                                .stroke(.black, lineWidth: 5)
                                .background(.blue)
                                .cornerRadius(5)
                                .overlay(
                                    Text("Join now")
                                        .font(.custom("EBGaramond-Regular", size: 20))
                                        .foregroundColor(.white)
                                )
                        )
                        .onTapGesture {
                            addMemberToGroup(userId: getAuthToken()!, groupId: group!.groupId, name: getLoginToken()!){ result in
                                print(result)
                            }
                            isJoined = true
                        }
                }
                if isJoined {
                    
                    HStack {
                        Rectangle()
                            .cornerRadius(5)
                            .offset(x: 4, y: 4)
                            .frame(height: 50)
                            .overlay(
                                Rectangle()
                                    .stroke(.black, lineWidth: 5)
                                    .background(.purple)
                                    .cornerRadius(5)
                                    .overlay(
                                        Text("Activities")
                                            .font(.custom("EBGaramond-Regular", size: 20))
                                            .foregroundColor(.white)
                                    )
                            )
                            .onTapGesture {
                                activityOpen = true
                            }
                        
                        Rectangle()
                            .cornerRadius(5)
                            .offset(x: 4, y: 4)
                            .frame(height: 50)
                            .overlay(
                                Rectangle()
                                    .stroke(.black, lineWidth: 5)
                                    .background(.green)
                                    .cornerRadius(5)
                                    .overlay(
                                        Text("Chats")
                                            .font(.custom("EBGaramond-Regular", size: 20))
                                            .padding(.leading, 10)
                                            .foregroundColor(.white)
                                    )
                            )
                            .onTapGesture {
                                chatOpen = true
                            }
                    }
                }
                
                Spacer()
            }
        }
        .onAppear{
            checkIfMemberInGroup(userId: getAuthToken()!, groupId: group!.groupId) { result in
                print(result)
                if result == "Member exists in the group"{
                    isJoined = true
                }
            }
        }
        .sheet(isPresented: $chatOpen) {
            GroupChatView(groupId: group!.groupId)
        }
        .sheet(isPresented: $activityOpen) {
            ActivityView(groupId: group!.groupId)
        }
    }
}

