//
//  CustomController.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 25/06/2023.
//

import Foundation
import SwiftUI

func returnBoxColor(params: Double) -> Color {
    if params  > 7 {
        return Color.green
    } else if params >= 4 {
        return Color.orange
    } else {
        return Color.red
    }
}
