//
//  Models.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 22/06/2023.
//

import Foundation

struct TabItemData {
    let image: String
    let selectedImage: String
    let title: String
}

struct Mood: Identifiable, Codable, Hashable {
    let id: String
    let appetite: String
    let context: String
    let energyLevel: String
    let mood: String
    let notes: String
    let rating: String
    let sleepQuality: String
    let trigger: String
    let timestamp: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case appetite, context, energyLevel, mood, notes, rating, sleepQuality, trigger, timestamp
    }
}

struct DialogflowResponse: Codable {
    // Other properties
    
    let queryResult: QueryResult
    
    struct QueryResult: Codable {
        // Other properties
        
        let fulfillmentMessages: [FulfillmentMessage]
        
        struct FulfillmentMessage: Codable {
            let text: TextMessage
            
            struct TextMessage: Codable {
                let text: [String]
            }
        }
    }
}

struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    var text: String
    let isUser: Bool
    var isLoading: Bool
    var userId: String?
}

struct Groups: Codable {
    let name: String
    let description: String
    let facilitators: [Facilitator]
    let members: [Member]
    let meetingSchedule: MeetingSchedule
    let rules: [String]
    let createdAt: String
    let updatedAt: String
    let groupId: String
}


struct Facilitator: Codable {
    let userid: String
}

struct Member: Codable {
    let userId: String
    let name: String
}

struct MeetingSchedule: Codable {
    let day: String
    let time: String
}


struct GroupChat: Codable {
    let groupId: String
    let name: String
    let participants: [Participant]
    let messages: [Message]
    let createdAt: String
    let updatedAt: String
}

struct Participant: Codable {
    let userId: String
    let username: String
}

struct Message: Codable {
    let messageId: String
    let sender: Participant
    let content: String
    let timestamp: String
}

struct Activity: Codable {
    let userId: String
    let name: String
    let description: String
    let timestamp: String
}

struct ActivityData: Codable {
    let _id: String
    let activity: [Activity]
    let createdAt: String
    let groupId: String
}
