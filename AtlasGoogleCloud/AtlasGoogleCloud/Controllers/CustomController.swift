//
//  CustomController.swift
//  AtlasGoogleCloud
//
//  Created by Amey Sunu on 25/06/2023.
//

import Foundation
import SwiftUI

func returnBoxColor(params: String) -> Color {
    let doubleParams = Double(params)
    if doubleParams!  > 7 {
        return Color.green
    } else if doubleParams! >= 4 {
        return Color.orange
    } else {
        return Color.red
    }
}
