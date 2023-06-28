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
