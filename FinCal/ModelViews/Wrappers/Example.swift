//
//  Example.swift
//  FinCal
//
//  Created by Yasin on 3/7/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

enum KeyboardType: Int {
    case DECIMAL, NUMBER
}

enum SuffixType: Int {
    case PERCENTAGE, CURRENCY, NONE
}

struct CustomUIKitTextField: UIViewRepresentable {
    
    var keyboardType: KeyboardType
    var suffixType: SuffixType
    var placeholder: String
    
    @Binding var text: String // Two way bindable state
    
    func makeUIView(context: UIViewRepresentableContext<CustomUIKitTextField>) -> UITextField {
        
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        
        if keyboardType == .DECIMAL {
            textField.keyboardType = .decimalPad
        } else {
            textField.keyboardType = .numberPad
        }
        
        if suffixType == .NONE {
            return textField
        } else {
            
            let suffix = UILabel()
                
            if suffixType == .CURRENCY {
                suffix.text = "$"
                textField.leftView = suffix
                textField.leftViewMode = .always // or .always .whileEditing
            } else {
                suffix.text = "%"
                textField.rightView = suffix
                textField.rightViewMode = .always // or .always .whileEditing
            }
            
            suffix.textColor = UIColor.darkGray
            suffix.sizeToFit()
            return textField
            
        }
        
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomUIKitTextField>) {
        uiView.text = text
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func makeCoordinator() -> CustomUIKitTextField.Coordinator {
        Coordinator(parent: self)
    }
    
    /// coordinator class for delegating UITextField behaviour
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var parent: CustomUIKitTextField
        
        init(parent: CustomUIKitTextField) {
            self.parent = parent
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            
            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1
            
            let numberOfDecimalDigits: Int
            if let dotIndex = newText.firstIndex(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            
            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
            
        }
        
    }
}
