//
//  KeyboardResponder.swift
//  FinCal
//
//  Created by Yasin on 3/5/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    
    let didChange = PassthroughSubject<CGFloat, Never>()
    
    private var _center: NotificationCenter
    private(set) var currentHeight: CGFloat = 0 {
        didSet {
            didChange.send(currentHeight)
        }
    }
    
    init(center: NotificationCenter = .default) {
        _center = center
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        _center.removeObserver(self)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        print("keyboard will show")
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }
    
    @objc func keyBoardWillHide(notification: Notification) {
        print("keyboard will hide")
        currentHeight = 0
    }
    
}
