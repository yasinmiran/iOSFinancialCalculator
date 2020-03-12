//
//  SheetHelper.swift
//  FinCal
//
//  Created by Yasin on 3/10/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import Foundation
import SwiftUI

struct ModalControlBar: View {
    
    @Binding var showingHelpView: Bool
    
    var body: some View {
        Group {
            CustomVerticalSpacer(top: 2, bottom: 2)
            HStack(alignment: .center, spacing: 10) {
                Spacer()
                Button(action: {
                    self.showingHelpView = false
                }) {
                    Text("Close")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: 0xff1744))
                    Image(systemName: "xmark")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: 0xd32f2f))
                }
            }
            .frame(minWidth: 100, maxWidth: .infinity)
        }
        
    }
    
}

struct ModalDescription: View {
    
    let title: String
    let shortDesc: String
    
    var body: some View {
        Group {
            VStack {
                Section(
                    header: Text(title.uppercased())
                        .font(.title)
                        .padding()) {
                            Text(shortDesc)
                                .font(.caption)
                                .fontWeight(.light)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 2)
                }
            }
            .padding(.horizontal, 2)
            .frame(minWidth: 0, maxWidth: .infinity)
            Divider()
            CustomVerticalSpacer(top: 3, bottom: 1)
        }
    }
}

struct FieldDescriptor: View {
    
    let instructionTitle: String
    let instructionDesc: String
    
    var body: some View {
        Group {
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    Text(instructionTitle)
                        .font(.caption)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 2)
                .frame(minWidth: 0, maxWidth: .infinity)
                
                HStack(alignment: .firstTextBaseline) {
                    Text(instructionDesc)
                        .font(.caption)
                        .fontWeight(.light)
                        .italic()
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                        .lineSpacing(2)
                    Spacer()
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 2)
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding(.all, 8)        }
        
    }
    
}


struct ModalCard_Previews: PreviewProvider {
    static var previews: some View {
        FieldDescriptor(
            instructionTitle: "Present Value",
            instructionDesc: "Some sample text. Some sample text."
        ).previewLayout(.sizeThatFits)
    }
}
