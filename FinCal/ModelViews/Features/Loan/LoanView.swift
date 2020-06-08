//
//  LoanView.swift
//  FinCal
//
//  Created by Yasin on 3/6/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import SwiftUI
import Combine

struct LoanView: View {
    
    @ObservedObject var viewModel = Loan()
    @State var showingHelpView: Bool = false
    
    var body: some View {
        
        NavigationViewWrapper(
            content: KeyboardAvoider {
                VStack {
                    Divider()
                    CustomVerticalSpacer(top: 10, bottom: 0)
                    _loanAmountTXTField()
                    _interestTXTField()
                    _monthlyPaymentTXTField()
                    _noOfMonthsTXTField()
                    CalculateButton(
                        text: "Calculate Loan",
                        action: { self.viewModel.calculate() },
                        disabled: $viewModel.calculationsDisabled
                    )
                }
            }
            .sheet(
                isPresented: $showingHelpView,
                content: { LoanHelpView(showingHelpView: self.$showingHelpView) }
            ),
            navBarTitle: "Loans",
            showingHelpView: $showingHelpView
        ).alert(isPresented: $viewModel.showAlert) { _presentAlert() }
        
    }
    
    func _loanAmountTXTField() -> some View {
        return LabeldTextField(
            label: "Loan Amount",
            placeholder: "100000",
            suffix: .CURRENCY,
            keypad: .DECIMAL,
            validator: nil,
            lineLimit: 15,
            disabled: false,
            text: $viewModel.loanAmount
        )
    }
    
    func _interestTXTField() -> some View {
        return LabeldTextField(
            label: "Interest",
            placeholder: "5.3",
            suffix: .PERCENTAGE,
            keypad: .DECIMAL,
            validator: { val in
                if let percent = Double(val) {
                    return percent >= 0 && percent <= 100
                }
                return false
        },
            lineLimit: 5,
            disabled: false,
            text: $viewModel.interest
        )
    }
    
    func _monthlyPaymentTXTField() -> some View {
        return  LabeldTextField(
            label: "Monthly Installment",
            placeholder: "25000",
            suffix: .CURRENCY,
            keypad: .DECIMAL,
            validator: nil,
            lineLimit: 15,
            disabled: false,
            text: $viewModel.monthlyPayment
        )
    }
    
    func _noOfMonthsTXTField() -> some View {
        return LabeldTextField(
            label: "Number of Months",
            placeholder: "22",
            suffix: .POUND,
            keypad: .DECIMAL,
            validator: nil,
            lineLimit: 15,
            disabled: false,
            text: $viewModel.durationInTerms
        )
    }
    
    func _presentAlert() -> Alert {
        /// Force unwrapping is done because when the showAlert is
        /// true, a value for viewAlert is already assigned
        return Alert(
            title: Text(viewModel.viewAlert!.title),
            message: Text(viewModel.viewAlert!.body),
            dismissButton: .default(Text(viewModel.viewAlert!.actionButtonText), action: {
                self.viewModel.viewAlert = nil
            })
        )
    }
    
}

struct LoanView_Previews: PreviewProvider {
    static var previews: some View {
        LoanView(showingHelpView: true)
    }
}
