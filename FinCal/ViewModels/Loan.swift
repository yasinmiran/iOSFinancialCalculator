//
//  Loan.swift
//  FinCal
//
//  Created by Yasin on 3/6/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import Foundation
import Combine

class Loan: ObservableObject {
    
    /// variables that are decorated using @Published allows the
    /// loan view to get notified when its value got changed.
    @Published var loanAmount: String = "" { didSet { checkValidity() } }
    @Published var interest: String = "" { didSet { checkValidity() } }
    @Published var monthlyPayment: String = "" { didSet { checkValidity() } }
    @Published var durationInTerms: String = "" { didSet { checkValidity() } }
    
    /// To show an alert in the model view. Once the
    /// showAlert is set to false, the UI will immediately
    /// display the viewAlert object. viewAlert is allocated
    /// before setting showAlert.
    @Published var showAlert: Bool = false
    @Published var viewAlert: ViewAlertMessage? = nil
    
    /// To indicate the view whether the calculator button should be disabled
    @Published var calculationsDisabled: Bool = true
    
    init() {
        loadSavedState()
    }
    
    /// checks whether the current state values are ready to calculate
    /// the different operations.
    func checkValidity() -> Void {
        var propCount = 0;
        if !loanAmount.isEmpty && Double(loanAmount) != 0 { propCount += 1 }
        if !interest.isEmpty { propCount += 1 }
        if !monthlyPayment.isEmpty && Double(monthlyPayment) != 0 { propCount += 1 }
        if !durationInTerms.isEmpty && Double(durationInTerms) != 0 { propCount += 1 }
        calculationsDisabled = propCount == 3 ? false : true
    }
    
    /// Calculating the missing value
    func calculate() -> Void {
        
        // Check one more time before calculation
        self.checkValidity()
        if calculationsDisabled {
            viewAlert = ViewAlertMessage(
                title: "Unable to Calculate",
                body: "To calculate, atleast 1 entry must left empty!",
                actionButtonText: "Got It!"
            )
            showAlert = true
            return
        }
        
        if loanAmount.isEmpty {
            self.calculateMissingLoanAmount()
            
        } else if monthlyPayment.isEmpty {
            self.calculateMissingMonthlyPayment()
            
        } else if durationInTerms.isEmpty {
            do {
                try self.calculateMissingTerms()
            } catch /*let _*/ {
                viewAlert = ViewAlertMessage(
                    title: "Unreal Monthly Payment",
                    body:"""
                           Seems like your payment is not enough to pay the loan interest on time.
                           Thus, it is not enough to ever pay off the loan.
                           """,
                    actionButtonText: "Got It!"
                )
                self.showAlert = true
            }
            
        } else {
            self.calculateMissingInterest()
        }
        
        persistCurrentState()
        
    }
    
    func calculateMissingLoanAmount() -> Void {
        let PMT = Double(monthlyPayment)!
        let I = Double(interest)! / 100.0 / 12;
        let N = Double(durationInTerms)!
        let PV = Double((PMT / I) * (1 - (1 / pow(1 + I, N)))).toFixed(2)
        loanAmount = String(PV)
    }
    
    func calculateMissingMonthlyPayment() -> Void {
        let I = Double(interest)! / 100.0 / 12
        let PV = Double(loanAmount)!
        let N = Double(durationInTerms)!
        let PMT = Double((I * PV) / (1 - pow(1 + I, -N))).toFixed(2)
        monthlyPayment = String(PMT)
    }
    
    func calculateMissingTerms() throws -> Void {
        
        /// Find the min monthly payment first. Because if the user entered
        /// monthly payment is less than the minimum payment relative to
        /// the interest rate. Then it's not enough to payoff the loan
        
        let M_I = Double(interest)! / 100.0 / 12
        let M_PV = Double(loanAmount)!
        let M_N = 1.0
        let MP = (M_I * M_PV) / (1 - pow(1 + M_I, -M_N))
        let MIN_P = MP - M_PV
        
        /// Throw an exception to show a alert to the user
        if Int(Double(monthlyPayment)!) <= Int(MIN_P) {
            throw CalculationError.runtimeError("loan underpayment")
        }
        
        let PMT = Double(monthlyPayment)!
        let PV = Double(loanAmount)!
        let I = Double(interest)! / 100.0 / 12;
        let D = PMT / I
        let N = (log(D/(D-PV)) / log(1+I))
        
        durationInTerms = String(N.rounded().toFixed(2)) // Showed as months
        
    }
    
    func calculateMissingInterest() -> Void {
        
        let T = Double(durationInTerms)!
        let PA = Double(loanAmount)!
        let P = Double(monthlyPayment)!
        
        /// The interest is calculated using the newton-raphson-method.
        /// Using convoluted linear formular to compute the value for i
        /// https://rinterested.github.io/statistics/newton_raphson_method.html
        
        var x = 1 + (((P*T/PA) - 1) / 12) // Initial Guess ~ 10%
        let FINANCIAL_PRECISION = Double(0.000001) // 1e-6
        
        func F(_ x: Double) -> Double { // f(x)
            // (loan * x * (1 + x)^n) / ((1+x)^n - 1) - pmt
            return Double(PA * x * pow(1 + x, T) / (pow(1+x, T) - 1) - P);
        }
        
        func FPrime(_ x: Double) -> Double { // f'(x)
            // (loan * (x+1)^(n-1) * ((x*(x+1)^n + (x+1)^n-n*x-x-1)) / ((x+1)^n - 1)^2)
            let c_derivative = pow(x+1, T)
            return Double(PA * pow(x+1, T-1) *
                (x * c_derivative + c_derivative - (T*x) - x - 1)) / pow(c_derivative - 1, 2)
        }
        
        while(abs(F(x)) > FINANCIAL_PRECISION) {
            x = x - F(x) / FPrime(x)
        }
        
        /// Convert to yearly interest & transform into a percentage
        /// with two decimal fraction digits.
        let I = Double(12 * x * 100).toFixed(2)
        
        if I.isNaN || I.isInfinite || I < 0 {
            interest = "0.00"
        } else {
            interest = String(I)
        }
        
    }
    
    //func amortizeLoan() -> Void {
    //
    //}
    
    func loadSavedState() -> Void {
        
        let ud = UserDefaults.standard
        
        self.loanAmount = ud.object(forKey: "dev.yazeen.fincal.loan.loanAmount") as? String ?? ""
        self.interest = ud.object(forKey: "dev.yazeen.fincal.loan.interest") as? String ?? ""
        self.monthlyPayment = ud.object(forKey: "dev.yazeen.fincal.loan.monthlyPayment") as? String ?? ""
        self.durationInTerms = ud.object(forKey: "dev.yazeen.fincal.loan.durationInTerms") as? String ?? ""
        
    }
    
    func persistCurrentState() -> Void {
        
        let ud = UserDefaults.standard
        
        ud.set(self.loanAmount, forKey: "dev.yazeen.fincal.loan.loanAmount")
        ud.set(self.interest, forKey: "dev.yazeen.fincal.loan.interest")
        ud.set(self.monthlyPayment, forKey: "dev.yazeen.fincal.loan.monthlyPayment")
        ud.set(self.durationInTerms, forKey: "dev.yazeen.fincal.loan.durationInTerms")
        
    }
    
}
