//
//  SavingsView.swift
//  FinCal
//
//  Created by Yasin on 3/8/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

///  `Compound Savings with Regular Contributions`

import SwiftUI

struct SavingsView: View {
    
    /// ViewModel of this screen.
    @ObservedObject var viewModel = Savings()
    @State var showingHelpView: Bool = false
    
    var body: some View {
        
        NavigationViewWrapper(
            content: KeyboardAvoider {
                VStack {
                    Divider()
                    CustomVerticalSpacer(top: 10, bottom: 0.0)
                    _presentValueTXTField()
                    _interestRateTXTField()
                    _depositATPeriodToggle()
                    _paymentTXTField()
                    _compoundsPYTXTField()
                    _futureValueTXTField()
                    _noOfYearsTXTField()
                    CalculateButton(
                        text: "Calculate Compound Savings",
                        action: { self.viewModel.calculate() },
                        disabled: $viewModel.calculationsDisabled
                    )
                }
            }
            .sheet(
                isPresented: $showingHelpView,
                content: { SavingsHelpView(showingHelpView: self.$showingHelpView) }
            ),
            navBarTitle: "Savings",
            showingHelpView: $showingHelpView
        ).alert(isPresented: $viewModel.showAlert) { _presentAlert() }
        
    }
    
    func _presentValueTXTField() -> LabeldTextField {
        return LabeldTextField(
            label: "Present Value",
            placeholder: "100000.00",
            suffix: .CURRENCY,
            keypad: .DECIMAL,
            validator: nil,
            lineLimit: 15,
            disabled: false,
            text: $viewModel.presentValue
        )
    }
    
    func _interestRateTXTField() -> LabeldTextField {
        return LabeldTextField(
            label: "Interest",
            placeholder: "7.5",
            suffix: .PERCENTAGE,
            keypad: .DECIMAL,
            validator: { val in /// Custom validator function
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
    
    func _depositATPeriodToggle() -> some View {
        return VStack {
            Toggle(isOn: $viewModel.isBeginning) {
                HStack(alignment: .center, spacing: 20) {
                    Text("Deposit at Period")
                        .bold()
                    Divider()
                    Text(viewModel.isBeginning ? "Beginning of Month" : "End of Month")
                        .font(.caption)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    func _paymentTXTField() -> LabeldTextField {
        return LabeldTextField(
            label: "Payment Value",
            placeholder: "25000.00",
            suffix: .CURRENCY,
            keypad: .DECIMAL,
            validator: nil,
            lineLimit: 15,
            disabled: false,
            text: $viewModel.paymentValue
        )
    }
    
    func _compoundsPYTXTField() -> LabeldTextField {
        return LabeldTextField(
            label: "Compounds Per Year (Fixed)",
            placeholder: "12",
            suffix: .POUND,
            keypad: .NUMBER,
            validator: nil,
            lineLimit: 2,
            disabled: true,
            text: $viewModel.compoundsPerYear
        )
    }
    
    func _futureValueTXTField() -> LabeldTextField {
        return LabeldTextField(
            label: "Future Value",
            placeholder: "150000.00",
            suffix: .CURRENCY,
            keypad: .DECIMAL,
            validator: nil,
            lineLimit: 15,
            disabled: false,
            text: $viewModel.futureValue
        )
    }
    
    func _noOfYearsTXTField() -> LabeldTextField {
        return LabeldTextField(
            label: "Number of Years",
            placeholder: "12",
            suffix: .POUND,
            keypad: .NUMBER,
            validator: nil,
            lineLimit: 15,
            disabled: false,
            text: $viewModel.noOfYears
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

struct CompoundSavingsView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsView()
    }
}
