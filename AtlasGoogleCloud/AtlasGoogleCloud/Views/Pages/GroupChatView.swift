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
    @State private var userId = getLoginToken()

    func sendMessage() {
        let userMessage = ChatMessage(text: userInput, isUser: true, isLoading: false)
        messages.append(userMessage)

        sendMessageToGroup(groupId: groupId, userId: userId!, username: userId!, messageText: userInput) { result, error in
            print(result)
        }
    }

    var body: some View {
        VStack {
            Text("Chat")
                .font(.custom("EBGaramond-Regular", size: 20))
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(messages) { message in
                            HStack {
                                if let userId = message.userId {
                                    Text("\(userId): ")
                                        .font(.custom("EBGaramond-Regular", size: 20))
                                }
                                ChatBubble(message: message)
                            }
                        }
                    }
                }
                .padding()

                HStack {
                    TextField("Type a message...", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        sendMessage()
                        userInput = "" // Clear the text input after sending
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            getCurrentGroupChats(groupId: groupId) { result in
                guard let data = result.data(using: .utf8) else {
                    return
                }

                do {
                    let decodedData = try JSONDecoder().decode(GroupChat.self, from: data)
                    let messageData = decodedData.messages

                    messages = messageData.map { message in
                        let text = message.content
                        let isUser = message.sender.userId == userId
                        let userId = message.sender.username

                        return ChatMessage(text: text, isUser: isUser, isLoading: false, userId: userId)
                    }
                } catch {
                    print("Error decoding chat messages: \(error)")
                }
            }
        }
    }
}


struct GroupChatView_Previews: PreviewProvider {
    static var previews: some View {
        GroupChatView(groupId: "ABC")
    }
}
