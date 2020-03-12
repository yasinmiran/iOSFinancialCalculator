//
//  LabledTextField.swift
//  FinCal
//
//  Created by Yasin on 3/5/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct LabeldTextField: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    /// View conforming properties that must be
    /// passed from the parent of this view.
    let label: String
    let placeholder: String
    let suffix: SuffixType
    let keypad: KeyboardType
    let validator: ((_ value: String) -> Bool)?
    let lineLimit: Int
    let disabled: Bool
    
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(self.label)
                .foregroundColor(colorScheme == .light ? .black : .white)
                .font(.callout)
                .truncationMode(.tail)
            CustomUIKitTextField(
                keyboardType: self.keypad,
                suffixType: self.suffix,
                placeholder: self.placeholder,
                validator: self.validator,
                lineLimit: self.lineLimit,
                disabled: self.disabled,
                text: $text
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
}

enum KeyboardType: Int {
    case DECIMAL, NUMBER
}

enum SuffixType: Int {
    case PERCENTAGE, CURRENCY, POUND, NONE
}

struct CustomUIKitTextField: UIViewRepresentable {
    
    var keyboardType: KeyboardType
    var suffixType: SuffixType
    var placeholder: String
    var validator: ((_ value: String) -> Bool)?
    var lineLimit: Int
    var disabled: Bool
    
    @Binding var text: String /// Two way bindable state
    
    func makeUIView(context: UIViewRepresentableContext<CustomUIKitTextField>) -> UITextField {
        
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = !self.disabled
        textField.clearButtonMode = .always
        textField.autocorrectionType = .no
        textField.addDoneCancelToolbar()
        
        if self.disabled {
            textField.alpha = 0.4
        }
        
        if keyboardType == .DECIMAL {
            textField.keyboardType = .decimalPad
        } else {
            textField.keyboardType = .numberPad
        }
        
        if suffixType == .NONE {
            return textField
        } else {
            
            let suffix = UILabel()
            
            /// applies the desired suffix or prefix into the text field
            if suffixType == .CURRENCY {
                suffix.text = "  $"
                textField.leftView = suffix
                textField.leftViewMode = .always
            } else if suffixType == .PERCENTAGE {
                suffix.text = "  %"
                textField.leftView = suffix
                textField.leftViewMode = .always
            } else {
                suffix.text = "  #"
                textField.leftView = suffix
                textField.leftViewMode = .always
            }
            
            /// apply the properties of the label
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
            
            /// Backspace erase
            if string.isEmpty {
                return true
            }
            
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true /// if this is a initial keypress
            }
            
            /// Check if count already exceeding
            if self.parent.lineLimit != Int.max {
                if (oldText + string).count > self.parent.lineLimit {
                    return false
                }
            }
            
            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1
            
            /// check if the resulting text is similar to 00 or 07
            let hasLeadingZeros = newText.range(
                of: "^(?:0{2,}|0\\d)",
                options: .regularExpression,
                range: nil, locale: nil
                ) != nil
            if hasLeadingZeros { return false }
            
            /// count the number of decimal dots in the resulting text
            let numberOfDecimalDigits: Int
            if let dotIndex = newText.firstIndex(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            
            /// check if all the common validation is passed. else just return false without calling the
            /// custom validator function passed by the parent view.
            if isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 {
                /// the only remaining validation is the custom one. so if theres a validation
                /// function present then execute and return it's result or just return true.
                if parent.validator != nil {
                    return parent.validator!(oldText + string)
                }
                /// if there's no custom validation function passed to this textfield
                return true
            } else {
                return false
            }
            
        }
    }
    
}

/* Debug only */
struct LabeldTextField_Previews: PreviewProvider {
    static var previews: some View {
        LabeldTextField(
            label: "Some label text goes here",
            placeholder: "Some placeholder text goes here",
            suffix: .NONE,
            keypad: .NUMBER,
            validator: nil,
            lineLimit: 10,
            disabled: false,
            text: .constant("placeholder")
        ).previewLayout(.sizeThatFits)
    }
}
