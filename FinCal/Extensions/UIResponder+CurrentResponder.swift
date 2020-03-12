//
//  UIResponder+CurrentResponder.swift
//  FinCal
//
//  Created by Yasin on 3/8/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import SwiftUI
import UIKit

extension UIResponder {
    
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    static func current() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(
            #selector(UIResponder.trap),
            to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func trap() {
        Static.responder = self
    }
    
}
