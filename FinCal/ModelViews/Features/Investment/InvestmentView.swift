//
//  InvestmentView.swift (Compound Savings (Fixed))
//  FinCal
//
//  Created by Yasin on 3/8/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

/// `Compound Savings without Regular Contributions (Fixed sum investment)`

import SwiftUI

struct InvestmentView: View {
    
    @ObservedObject var viewModel = Investment()
    @State var showingHelpView: Bool = false
    
    var body: some View {
        
        NavigationViewWrapper(
            content: KeyboardAvoider {
                VStack {
                    Divider()
                    CustomVerticalSpacer(top: 10, bottom: 0)
                    _presentValueTXTField()
                    _interestTXTField()
                    _compoundsPYTXTField()
                    _futureValueTXTField()
                    _noOfYearsTXTField()
                    CalculateButton(
                        text: "Calculate Investment",
                        action: { self.viewModel.calculate() },
                        disabled: $viewModel.calculationsDisabled
                    )
                }
            }
            .sheet(
                isPresented: $showingHelpView,
                content: {
                    InvestmentHelpView(showingHelpView: self.$showingHelpView)
                    
            }),
            navBarTitle: "Investment",
            showingHelpView: $showingHelpView
        ).alert(isPresented: $viewModel.showAlert) { _presentAlert() }
        
    }
    
    func _presentValueTXTField() -> some View {
        return LabeldTextField(
            label: "Present Value",
            placeholder: "100000",
            suffix: .CURRENCY,
            keypad: .DECIMAL,
            validator: nil,
            lineLimit: 15,
            disabled: false,
            text: $viewModel.presentValue
        )
    }
    
    func _interestTXTField() -> some View {
        return LabeldTextField(
            label: "Interest",
            placeholder: "2.6",
            suffix: .PERCENTAGE,
            keypad: .DECIMAL,
            validator: nil,
            lineLimit: 15,
            disabled: false,
            text: $viewModel.interest
        )
    }
    
    func _compoundsPYTXTField() -> some View {
        return LabeldTextField(
            label: "Compounds Per Year (Fixed)",
            placeholder: "12", // 4, 3, 6 (our requirement is only for months)
            suffix: .POUND,
            keypad: .NUMBER,
            validator: nil,
            lineLimit: 2, // Fixed because of 12
            disabled: true,
            text: $viewModel.compoundsPerYear
        )
    }
    
    func _futureValueTXTField() -> some View {
        return LabeldTextField(
            label: "Future Value",
            placeholder: "125000",
            suffix: .CURRENCY,
            keypad: .DECIMAL,
            validator: nil,
            lineLimit: 15,
            disabled: false,
            text: $viewModel.futureValue
        )
    }
    
    func _noOfYearsTXTField() -> some View {
        return LabeldTextField(
            label: "Number of Years",
            placeholder: "24",
            suffix: .POUND,
            keypad: .DECIMAL,
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

struct CompoundSavingsFSView_Previews: PreviewProvider {
    static var previews: some View {
        InvestmentView()
    }
}
