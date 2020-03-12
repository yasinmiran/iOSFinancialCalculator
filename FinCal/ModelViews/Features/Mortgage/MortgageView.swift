//
//  MortgageView.swift
//  FinCal
//
//  Created by Yasin on 3/6/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import SwiftUI

struct MortgageView: View {
    
    @ObservedObject var viewModel = Mortgage()
    @State var showingHelpView: Bool = false
    
    var body: some View {
        
        NavigationViewWrapper(
            content: KeyboardAvoider {
                VStack {
                    Divider()
                    CustomVerticalSpacer(top: 10, bottom: 0)
                    _principalAmtTXTField()
                    _interestTXTField()
                    _monthlyPaymentTXTField()
                    _noOfYearsTXTField()
                    CalculateButton(
                        text: "Calculate Mortgage",
                        action: { self.viewModel.calculate()},
                        disabled: $viewModel.calculationsDisabled
                    )
                }
            }
            .sheet(
                isPresented: $showingHelpView,
                content: { MortgageHelpView(showingHelpView: self.$showingHelpView) }
            ),
            navBarTitle: "Mortgage",
            showingHelpView: $showingHelpView
        ).alert(isPresented: $viewModel.showAlert) { _presentAlert() }
        
    }
    
    func _principalAmtTXTField() -> some View {
        return LabeldTextField(
            label: "Principal Amount",
            placeholder: "100000",
            suffix: .CURRENCY,
            keypad: .DECIMAL,
            validator: nil,
            lineLimit: 15,
            disabled: false,
            text: $viewModel.principalAmount
        )
    }
    
    func _interestTXTField() -> some View {
        return LabeldTextField(
            label: "Interest",
            placeholder: "7.5",
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
            text: $viewModel.interestRate
        )
    }
    
    func _monthlyPaymentTXTField() -> some View {
        return LabeldTextField(
            label: "Monthly Payment",
            placeholder: "25000",
            suffix: .CURRENCY,
            keypad: .DECIMAL,
            validator: nil,
            lineLimit: 15,
            disabled: false,
            text: $viewModel.monthlyPayment
        )
    }
    
    func _noOfYearsTXTField() -> some View {
        return LabeldTextField(
            label: "Number of Years",
            placeholder: "2.5",
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

struct MortgageView_Previews: PreviewProvider {
    static var previews: some View {
        MortgageView()
    }
}
