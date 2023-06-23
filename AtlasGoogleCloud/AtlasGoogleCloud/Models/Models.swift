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

struct Moods: Identifiable {
    let id: String
    let mood: String
    // Add other properties as needed
}
