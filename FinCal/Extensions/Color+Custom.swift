//
//  Color+Custom.swift
//  FinCal
//
//  Created by Yasin on 3/9/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import SwiftUI

extension Color {
    
    static let primaryButton = Color("primaryButton")
    
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
    
}
