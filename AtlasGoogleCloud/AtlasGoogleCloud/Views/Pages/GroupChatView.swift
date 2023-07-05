//
//  GroupChatView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 05/07/2023.
//

import SwiftUI

struct GroupChatView: View {
    
    @State var groupId: String
    @State private var messages: [ChatMessage] = []
    @State private var userInput = ""
    
    var body: some View {
        VStack {
            Text("Chat")
                .font(.custom("EBGaramond-Regular", size: 20))
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                        }
                    }
                }
                .padding()
                
                HStack {
                    TextField("Type a message...", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action:{
                        
                    }){
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
        }
        .onAppear{
            getCurrentGroupChats(groupId: groupId) { result in
                print(result)
            }
        }
    }
}

struct GroupChatView_Previews: PreviewProvider {
    static var previews: some View {
        GroupChatView(groupId: "ABC")
    }
}
