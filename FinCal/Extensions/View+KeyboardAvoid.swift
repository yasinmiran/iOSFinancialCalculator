//
//  View+KeyboardAvoid.swift
//  FinCal
//
//  Created by Yasin on 3/8/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import SwiftUI

extension View {
    public func avoidKeyboard() -> some View {
        modifier(KeyboardAvoiderModifier())
    }
}
