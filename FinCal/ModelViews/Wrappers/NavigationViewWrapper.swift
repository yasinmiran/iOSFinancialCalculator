//
//  NavigationViewWrapper.swift
//  FinCal
//
//  Created by Yasin on 3/5/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import SwiftUI

struct NavigationViewWrapper<Content:View>: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var content: Content
    var navBarTitle: String
    @Binding var showingHelpView: Bool
    
    public var body: some View {
        
        NavigationView {
            self.content
                .navigationBarItems(trailing: Button(action: {
                    self.showingHelpView = true
                }, label: {
                    HStack {
                        Text("Help")
                            .font(.callout)
                            .foregroundColor(Color(hex: 0x4caf50))
                            .multilineTextAlignment(.center)
                        Image(systemName: "questionmark.circle.fill")
                            .font(.title)
                            .foregroundColor(Color(hex: 0x64dd17))
                    }
                }))
                .navigationBarTitle(
                    Text(self.navBarTitle)
                        .foregroundColor(Color.white),
                    displayMode: .large
            )
        }.onTapGesture(count: 2) {
            // hides the keyboard when clicked anywhere inside the navigation view
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            keyWindow?.endEditing(true)
        }
        //.edgesIgnoringSafeArea(.bottom)
        .background(colorScheme == .light ? Color.white : Color.primary)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct NavigationViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        NavigationViewWrapper(
            content: Text("Navigation View"),
            navBarTitle: "Title",
            showingHelpView: .constant(true))
    }
}
