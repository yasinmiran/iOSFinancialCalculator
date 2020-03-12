//
//  MortgageHelpView.swift
//  FinCal
//
//  Created by Yasin on 3/10/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import SwiftUI

struct MortgageHelpView: View {
    
    @Binding var showingHelpView: Bool
    
    var body: some View {
        VStack {
            ModalControlBar(showingHelpView: $showingHelpView)
            ModalDescription(
                title: Constants.Mortgage_Title,
                shortDesc: Constants.Mortgage_Desc
            )
            FieldDescriptor(
                instructionTitle: Constants.Mortgage_PA,
                instructionDesc: Constants.Mortgage_PA_Desc
            )
            FieldDescriptor(
                instructionTitle: Constants.Mortgage_IR,
                instructionDesc: Constants.Mortgage_IR_Desc
            )
            FieldDescriptor(
                instructionTitle: Constants.Mortgage_PMT,
                instructionDesc: Constants.Mortgage_PMT_Desc
            )
            FieldDescriptor(
                instructionTitle: Constants.Mortgage_NM,
                instructionDesc:  Constants.Mortgage_NM_Desc
            )
            Spacer()
        }.padding(.horizontal, 15)
    }
    
}

struct MortgageHelpView_Previews: PreviewProvider {
    static var previews: some View {
        MortgageHelpView(showingHelpView: .constant(true))
    }
}
