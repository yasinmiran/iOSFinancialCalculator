//
//  TextFieldValidator.swift
//  FinCal
//
//  Created by Yasin on 3/7/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

protocol NewFormatter {
    
    associatedtype Value: Equatable

    /// The logic that converts your value to a string presented by the `TextField`. You should omit any values
    /// - Parameter object: The value you are converting to a string.
    func toString(object: Value) -> String

    /// Once the change is allowed and the input is final, this will convert
    /// - Parameter string: The full text currently on the TextField.
    func toObject(string: String) -> Value

    /// Specify if the value contains a final result. If it does not, nothing will be changed yet.
    /// - Parameter string: The full text currently on the TextField.
    func isFinal(string: String) -> Bool

    /// Specify **all** allowed inputs, **including** intermediate text that cannot be converted to your object **yet** but are necessary
    ///  in the input process for a final result. It will allow this input without changing your value until a final correct value can be determined.
    /// For example, `1.` is not a valid `Double`, but it does lead to `1.5`, which is. Therefore the `DoubleFormatter` would return true on `1.`.
    /// Returning false will reset the input to the previous allowed value.
    /// - Parameter string: The full text currently on the TextField.
    func allowChange(to string: String) -> Bool
    
}

struct NewTextField<T: NewFormatter>: View {
    
    let title: String
    let formatter: T
    
    @Binding var value: T.Value
    
    @State private var previous: T.Value
    @State private var previousGoodString: String? = nil

    init(_ title: String, value: Binding<T.Value>, formatter: T) {
        self.title = title
        self._value = value
        self._previous = State(initialValue: value.wrappedValue)
        self.formatter = formatter
    }

    var body: some View {
        let changedValue = Binding<String>(
            get: {
                if let previousGoodString = self.previousGoodString {
                    let previousValue = self.formatter.toObject(string: previousGoodString)

                    if previousValue == self.value {
                        return previousGoodString
                    }
                }

                let string = self.formatter.toString(object: self.value)
                return string
            },
            set: { newString in
                if self.formatter.isFinal(string: newString) {
                    let newValue = self.formatter.toObject(string: newString)
                    self.previousGoodString = newString
                    self.previous = newValue
                    self.value = newValue
                } else if !self.formatter.allowChange(to: newString) {
                    self.value = self.previous
                }
            }
        )

        return TextField(title, text: changedValue)
    }
}
