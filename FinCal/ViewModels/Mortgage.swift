//
//  MortgageModel.swift
//  FinCal
//
//  Created by Yasin on 3/6/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import Foundation
import Combine

final class Mortgage: ObservableObject {
    
    /// variables that are decorated using @Published allows the
    /// subscribers to get notified when its value got changed.
    @Published var principalAmount: String = "" { didSet { checkValidity() } }
    @Published var interestRate: String = "" { didSet { checkValidity() } }
    @Published var monthlyPayment: String = "" { didSet { checkValidity() } }
    @Published var durationInTerms: String = "" { didSet { checkValidity() } }
    
    /// to indicate whether the model is ready to calculate
    /// this property is for showing alerts only
    @Published var showAlert: Bool = false
    @Published var viewAlert: ViewAlertMessage? = nil
    
    /// To indicate the view whether the calculator button should be disabled
    @Published var calculationsDisabled: Bool = true
    
    init() {
        loadSavedState()
    }
    
    /// Checks whether the current state values are  ready to calculate
    /// the different operations.
    func checkValidity() -> Void {
        var propCount = 0;
        if !principalAmount.isEmpty && Double(principalAmount) != 0 { propCount += 1 }
        if !interestRate.isEmpty { propCount += 1 }
        if !monthlyPayment.isEmpty && Double(monthlyPayment) != 0 { propCount += 1 }
        if !durationInTerms.isEmpty && Double(durationInTerms) != 0 { propCount += 1 }
        calculationsDisabled = propCount == 3 ? false : true
    }
    
    func calculate() -> Void {
        
        // Check one more time before calculation
        self.checkValidity()
        if calculationsDisabled {
            viewAlert = ViewAlertMessage(
                title: "Unable to Calculate",
                body: "To calculate, atleast 1 entry must be left empty!",
                actionButtonText: "Got It!"
            )
            showAlert = true
            return
        }
        
        if principalAmount.isEmpty {
            self.calculateMissingPrincipalAmount()
            
        } else if monthlyPayment.isEmpty {
            self.calculateMissingMonthlyPayment()
            
        } else if durationInTerms.isEmpty {
            do {
                try self.calculateMissingTerms()
            } catch {
                viewAlert = ViewAlertMessage(
                    title: "Unreal Monthly Payment",
                    body:"""
                    Seems like your payment is not enough to pay the interest on time.
                    Thus it's not enough to ever pay off the loan.
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
    
    func calculateMissingPrincipalAmount() -> Void {
        
        let PMT = Double(monthlyPayment)!
        let I = Double(interestRate)! / 100.0 / 12;
        let N = Double(durationInTerms)! * 12
        let PV = Double((PMT / I) * (1 - (1 / pow(1 + I, N))))
        
        principalAmount = String(PV.toFixed(2))
        
    }
    
    func calculateMissingMonthlyPayment() -> Void {
        
        let I = (Double(interestRate)! / 100.0) / 12
        let PV = Double(principalAmount)!
        let N = Double(durationInTerms)! * 12
        let PMT = (PV * (I * pow(1 + I, N))) / (pow(1 + I, N) - 1)
        
        monthlyPayment = String(PMT.toFixed(2))
        
    }
    
    func calculateMissingTerms() throws -> Void {
        
        /// Find the min monthly payment first. Because if the user entered
        /// monthly payment is less than the minimum payment relative to
        /// the interest rate. Then it's not enough to payoff the loan
        
        let M_I = Double(interestRate)! / 100.0 / 12
        let M_PV = Double(principalAmount)!
        let M_N = 1.0
        let MP = (M_I * M_PV) / (1 - pow(1 + M_I, -M_N))
        let MIN_P = MP - M_PV
        
        /// Throw an exception to show a alert to the user
        if Int(Double(monthlyPayment)!) <= Int(MIN_P) {
            throw CalculationError.runtimeError("underpayment")
        }
        
        let PMT = Double(monthlyPayment)!
        let PV = Double(principalAmount)!
        let I = Double(interestRate)! / 100.0 / 12;
        let D = PMT / I
        let N = log(D/(D-PV)) / log(1+I)
        
        durationInTerms = String((N / 12).toFixed(2))
        
    }
    
    func calculateMissingInterest() -> Void {
        
        let T = Double(durationInTerms)! * 12
        let PA = Double(principalAmount)!
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
            interestRate = "0.00"
        } else {
            interestRate = String(I)
        }
        
    }
    
    func loadSavedState() -> Void {
        
        let ud = UserDefaults.standard
        
        self.principalAmount = ud.object(forKey: "dev.yazeen.fincal.mortgage.principalAmount") as? String ?? ""
        self.interestRate = ud.object(forKey: "dev.yazeen.fincal.mortgage.interestRate") as? String ?? ""
        self.monthlyPayment = ud.object(forKey: "dev.yazeen.fincal.mortgage.monthlyPayment") as? String ?? ""
        self.durationInTerms = ud.object(forKey: "dev.yazeen.fincal.mortgage.durationInTerms") as? String ?? ""
        
    }
    
    func persistCurrentState() -> Void {
        
        let ud = UserDefaults.standard
        
        ud.set(self.principalAmount, forKey: "dev.yazeen.fincal.mortgage.principalAmount")
        ud.set(self.interestRate, forKey: "dev.yazeen.fincal.mortgage.interestRate")
        ud.set(self.monthlyPayment, forKey: "dev.yazeen.fincal.mortgage.monthlyPayment")
        ud.set(self.durationInTerms, forKey: "dev.yazeen.fincal.mortgage.durationInTerms")
        
    }
    
}
