//
//  SavingsHelpView.swift
//  FinCal
//
//  Created by Yasin on 3/10/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import SwiftUI

struct SavingsHelpView: View {
    
    @Binding var showingHelpView: Bool
    
    var body: some View {
        
        VStack {
            
            ModalControlBar(showingHelpView: $showingHelpView)
            ModalDescription(
                title: Constants.Savings_Title,
                shortDesc: Constants.Savings_Desc
            )
            List {
                FieldDescriptor(
                    instructionTitle: Constants.Savings_PV,
                    instructionDesc: Constants.Savings_PV_Desc
                )
                FieldDescriptor(
                    instructionTitle: Constants.Savings_IR,
                    instructionDesc: Constants.Savings_IR_Desc
                )
                FieldDescriptor(
                    instructionTitle: Constants.Savings_DAP,
                    instructionDesc: Constants.Savings_DAP_Desc
                )
                FieldDescriptor(
                    instructionTitle: Constants.Savings_CPY,
                    instructionDesc: Constants.Savings_CPY_Desc
                )
                FieldDescriptor(
                    instructionTitle: Constants.Savings_FV,
                    instructionDesc: Constants.Savings_FV_Desc
                )
                FieldDescriptor(
                    instructionTitle: Constants.Savings_NY,
                    instructionDesc: Constants.Savings_NY_Desc
                )}
            Spacer()
            
        }.padding(.horizontal, 15)
    }
    
}

struct SavingsHelpView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsHelpView(showingHelpView: .constant(false))
    }
}
