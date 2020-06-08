//
//  CalculateButton.swift
//  FinCal
//
//  Created by Yasin on 3/6/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import SwiftUI
import Combine

struct CalculateButton: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let text: String
    let action: () -> Void
    
    @Binding var disabled: Bool
    @State var showInfoAlert: Bool = false
    
    var body: some View {
        HStack{
            Button(action: self.action, label: {
                Text(self.text)
                    .bold()
                    .foregroundColor(Color(hex: 0xbb4d00))
                    .font(.headline)
            })
                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 50)
                .background(Color(hex: 0xffad42))
                .cornerRadius(5)
                .disabled(disabled)
                .opacity(disabled ? 0.4 : 1)
                .onLongPressGesture { self.showInfoAlert.toggle() }
            
        }
        .alert(isPresented: $showInfoAlert) {
            Alert(
                title: Text("Why can't I calculate?"),
                message: Text("To calculate you must fill all the fields except the unknown subject."),
                dismissButton: .default(Text("Dismiss"))
            )
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 80)
        .padding(.horizontal, 20)
    }
    
}

struct CalculateButton_Previews: PreviewProvider {
    static var previews: some View {
        CalculateButton(
            text: "Sample Text",
            action: {},
            disabled: .constant(false)
        )
            .previewLayout(.sizeThatFits)
    }
}
