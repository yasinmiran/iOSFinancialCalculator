//
//  HelpView.swift
//  FinCal
//
//  Created by Yasin on 3/9/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import SwiftUI

struct LoanHelpView: View {
    
    @Binding var showingHelpView: Bool
    
    var body: some View {
        VStack {
            ModalControlBar(showingHelpView: $showingHelpView)
            ModalDescription(
                title: Constants.Loan_Title,
                shortDesc: Constants.Loan_Desc
            )
            FieldDescriptor(
                instructionTitle: Constants.Loan_PA,
                instructionDesc: Constants.Loan_PA_Desc
            )
            FieldDescriptor(
                instructionTitle: Constants.Loan_IR,
                instructionDesc: Constants.Loan_IR_Desc
            )
            FieldDescriptor(
                instructionTitle: Constants.Loan_PMT,
                instructionDesc: Constants.Loan_PMT_Desc
            )
            FieldDescriptor(
                instructionTitle: Constants.Loan_NM,
                instructionDesc:  Constants.Loan_NM_Desc
            )
            Spacer()
        }.padding(.horizontal, 15)
    }
    
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        LoanHelpView(showingHelpView: .constant(true))
    }
}
