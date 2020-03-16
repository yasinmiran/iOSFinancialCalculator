//
//  InvestmentHelpView.swift
//  FinCal
//
//  Created by Yasin on 3/10/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import SwiftUI

struct InvestmentHelpView: View {
    
    @Binding var showingHelpView: Bool
    
    var body: some View {
        VStack {
            ModalControlBar(showingHelpView: $showingHelpView)
            ModalDescription(
                title: Constants.Investment_Title,
                shortDesc: Constants.Investment_Desc
            )
            List {
                FieldDescriptor(
                    instructionTitle: Constants.Investment_PV,
                    instructionDesc: Constants.Investment_PV_Desc
                )
                FieldDescriptor(
                    instructionTitle: Constants.Investment_IR,
                    instructionDesc: Constants.Investment_IR_Desc
                )
                FieldDescriptor(
                    instructionTitle: Constants.Investment_CPY,
                    instructionDesc: Constants.Investment_CPY_Desc
                )
                FieldDescriptor(
                    instructionTitle: Constants.Investment_FV,
                    instructionDesc:Constants.Investment_FV_Desc
                )
                FieldDescriptor(
                    instructionTitle: Constants.Investment_NY,
                    instructionDesc:  Constants.Investment_NY_Desc
                )
            }
            Spacer()
        }.padding(.horizontal, 15)
    }
    
}

struct InvestmentHelpView_Previews: PreviewProvider {
    static var previews: some View {
        InvestmentHelpView(showingHelpView: .constant(true))
    }
}
