//
//  UITextField+DoneButton.swift
//  FinCal
//
//  Created by Yasin on 3/10/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        
        // let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.backgroundColor = .clear
        
        let barButton = UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        // barButton.width =  toolbar.frame.size.width
        
        toolbar.items = [
            //UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            //UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            barButton
            //UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
        ]
        
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
        
    }
    
    // Default actions:
    
    @objc func doneButtonTapped() {
        self.resignFirstResponder()
    }
    
    @objc func cancelButtonTapped() {
        self.resignFirstResponder()
    }
    
    // To override actions in another view:
    // myTextField.addDoneCancelToolbar(onDone: (target: self, action: #selector(self.tapDone)),
    // onCancel: (target: self, action: #selector(self.tapCancel)))
    
}
