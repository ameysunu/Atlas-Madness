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

struct Mood: Identifiable, Codable {
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
