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

struct ChatMessage: Identifiable {
    let id = UUID()
    var text: String
    let isUser: Bool
    var isLoading: Bool
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
