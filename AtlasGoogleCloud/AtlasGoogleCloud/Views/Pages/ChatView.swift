//
//  ChatView.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 27/06/2023.
//

import SwiftUI

struct ChatView: View {
    
    @State private var messages: [ChatMessage] = []
    @State private var userInput = ""
    @State var textLoading: Bool = false
    
    func sendMessage() {
        let userMessage = ChatMessage(text: userInput, isUser: true, isLoading: false)
        messages.append(userMessage)
        
        // Set the loading state for the bot message
        let botMessage = ChatMessage(text: "", isUser: false, isLoading: true)
        messages.append(botMessage)
        
        // Send user message to server and receive response
        sendQueryToDialogFlow(userText: userInput) { response in
            // Update the bot message with the response
            if let index = messages.firstIndex(where: { $0.id == botMessage.id }) {
                messages[index].text = response
                messages[index].isLoading = false
            }
        }
        
        userInput = ""
    }
    
    
    var body: some View {
        VStack {
            Text("Chat")
                .font(.custom("EBGaramond-Regular", size: 20))
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
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        Group {
            if message.isUser {
                VStack{
                    HStack {
                        Spacer()
                        Text(message.text)
                            .padding(12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                }
            } else {
                if message.isLoading {
                    HStack{
                        LoadingAnimation()
                        Spacer()
                    }
                } else {
                    HStack {
                        Text(message.text)
                            .padding(12)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

struct LoadingAnimation: View {
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .foregroundColor(isLoading ? .blue : .gray)
                    .frame(width: 10, height: 10)
                
                Circle()
                    .foregroundColor(isLoading ? .blue : .gray)
                    .frame(width: 10, height: 10)
                
                Circle()
                    .foregroundColor(isLoading ? .blue : .gray)
                    .frame(width: 10, height: 10)
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    func startAnimation() {
        withAnimation(Animation.linear(duration: 0.5).repeatForever()) {
            isLoading = true
        }
    }
}
