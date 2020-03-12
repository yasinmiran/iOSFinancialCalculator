//
//  Constants.swift
//  FinCal
//
//  Created by Yasin on 3/10/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import Foundation

final class Constants {
    
    // Investment
    
    static let Investment_Title = "Investment"
    static let Investment_Desc = "An investment is the purchase of goods that are not consumed today but are used in the future to create wealth."
    
    static let Investment_PV = "Present Value"
    static let Investment_PV_Desc = "The starting amount you invest in the account or your current balance in an existing investment account."
    
    static let Investment_IR = "Interest Rate"
    static let Investment_IR_Desc = "If you wish to calculate the interest rate based on other provided data."

    static let Investment_CPY = "Compounds per Year"
    static let Investment_CPY_Desc = "Number of compound payments per year (this calculator considers 12 payments per year, which conforms to monthly compounding)."

    static let Investment_FV = "Future Value"
    static let Investment_FV_Desc = "A future value of a series (expectation)."
    
    static let Investment_NY = "Number of Years"
    static let Investment_NY_Desc = "The time of investment or savings period."
    
    // Savings
    
    static let Savings_Title = "Savings"
    static let Savings_Desc = "Calculates the future value of your savings account."
    
    static let Savings_PV = "Present Value"
    static let Savings_PV_Desc = "The balance in your account that you are starting with, if any.  If none, enter 0."

    static let Savings_IR = "Interest Rate"
    static let Savings_IR_Desc = "This is the annual interest rate or 'stated rate' for your savings account."
    
    static let Savings_DAP = "Deposit at Period"
    static let Savings_DAP_Desc = "Beginning or end; for a monthly deposit example, will you making deposits at the beginning or end of each month?"

    static let Savings_CPY = "Compounds per Year"
    static let Savings_CPY_Desc = "Is the number of times compounding occurs per period. This calculator consider monthly compounds 12/yr"
  
    static let Savings_FV = "Future Value"
    static let Savings_FV_Desc = "Future savings based on the compounded series of calculation."

    static let Savings_NY = "No of Years"
    static let Savings_NY_Desc = "How far into the future will you be making these deposits?  This is the moment in time where the value of your account will be calculated."
    
    // Mortgage
    
    static let Mortgage_Title = "Mortgage"
    static let Mortgage_Desc = "A mortgage is a loan in which property or real estate is used as collateral. The borrower enters into an agreement with the lender wherein the borrower receives cash upfront then makes payments over a set time span until he pays back the lender in full."
    
    static let Mortgage_PA = "Mortgage Amount"
    static let Mortgage_PA_Desc = "The original principal amount of your mortgage when calculating a new mortgage or the current principal owed when calculating a current mortgage."
    
    static let Mortgage_IR = "Interest Rate"
    static let Mortgage_IR_Desc = "The annual nominal interest rate, or stated rate of the mortgage."

    static let Mortgage_PMT = "Monthly Installments"
    static let Mortgage_PMT_Desc = "The payment amount to be paid on this mortgage on a monthly basis toward principal and interest."

    static let Mortgage_NM = "Number of Months"
    static let Mortgage_NM_Desc = "The original term of your mortgage or the time left when calculating a current mortgage."

    // Loans
    
    static let Loan_Title = "Loans"
    static let Loan_Desc = "A loan is a contract between a borrower and a lender in which the borrower receives an amount of money (principal) that they are obligated to pay back in the future."
    
    static let Loan_PA = "Loan Amount"
    static let Loan_PA_Desc = "The original principal on a new loan or principal remaining on an existing loan."

    static let Loan_IR = "Interest Rate"
    static let Loan_IR_Desc = "The annual nominal interest rate, or stated rate of the loan."

    static let Loan_PMT = "Monthly Installments"
    static let Loan_PMT_Desc = "The amount to be paid toward the loan at each monthly payment due date."
    
    static let Loan_NM = "Number of Months"
    static let Loan_NM_Desc = "The number of payments required to repay the loan."
    
}
