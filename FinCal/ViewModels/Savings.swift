//
//  Savings.swift
//  FinCal
//
//  Created by Yasin on 3/8/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

///  `ViewModel For:`
///  `Compound Savings with Regular Contributions`

import Foundation
import Combine

final class Savings: ObservableObject {
    
    /// Variables that are decorated using @Published allows the
    /// subscribers to get notified when its value got changed.
    @Published var presentValue: String = "" { didSet{checkValidity()} }
    @Published var interest: String = "" { didSet{checkValidity()} }
    @Published var isBeginning: Bool = false { didSet{checkValidity()} }
    @Published var paymentValue: String = "" { didSet{checkValidity()} }
    @Published var compoundsPerYear: String = "12" { didSet{checkValidity()} }
    @Published var futureValue: String = "" { didSet{checkValidity()} }
    @Published var noOfYears: String = "" { didSet{checkValidity()} }
    
    /// To indicate whether the model is ready to calculate
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
        var propCount = 0
        if !presentValue.isEmpty { propCount += 1 }
        if !interest.isEmpty { propCount += 1 }
        if !paymentValue.isEmpty && Double(paymentValue) != 0 { propCount += 1 }
        if !futureValue.isEmpty && Double(futureValue) != 0 { propCount += 1 }
        if !noOfYears.isEmpty && Double(noOfYears) != 0 { propCount += 1 }
        calculationsDisabled =  propCount == 4 ? false : true
    }
    
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
        
        if presentValue.isEmpty {
            self.findMissingPresentValue()
            
        } else if futureValue.isEmpty {
            self.findMissingFutureValue()
            
        } else if noOfYears.isEmpty {
            self.findMissingNumberOfYears()
            
        } else if paymentValue.isEmpty {
            self.findMissingPaymentValue()
            
        } else {
            
            do {
                try self.findMissingInterest()
            } catch {
                viewAlert = ViewAlertMessage(
                    title: "Unsupported Operation",
                    body: "The system is currently unable to calulate interest for compound savings.",
                    actionButtonText: "Got It!"
                )
                self.showAlert = true
            }
            
        }
        
        persistCurrentState()
        
    }
    
    func findMissingPresentValue() -> Void {
        
        let FV = Double(futureValue)!
        let PMT = Double(paymentValue)!
        let I = Double(interest)! / 100
        let CPY = Double(compoundsPerYear)!
        let N = Double(noOfYears)!
        
        var PV: Double
        
        if isBeginning {
            PV = (FV - (PMT * (pow((1 + I / CPY), CPY * N) - 1) / (I / CPY)) * (1 + I / CPY)) / pow((1 + I / CPY), CPY * N)
        } else {
            PV = (FV - (PMT * (pow((1 + I / CPY), CPY * N) - 1) / (I / CPY))) / pow((1 + I / CPY), CPY * N)
        }
        
        presentValue = String(PV.toFixed(2))
        
    }
    
    func findMissingInterest() throws -> Void {
        // couldn't isolate the subject I in equation
        throw CalculationError.runtimeError("Unable to calculate interest rate!")
    }
    
    func findMissingPaymentValue() -> Void {
        
        let FV = Double(futureValue)!
        let PV = Double(presentValue)!
        let I = Double(interest)! / 100
        let CPY = Double(compoundsPerYear)!
        let N = Double(noOfYears)!
        
        var PMT: Double
        
        if isBeginning {
            PMT = Double((FV - (PV * pow((1 + I / CPY), CPY * N))) / ((pow((1 + I / CPY), CPY * N) - 1) / (I / CPY)))
        } else {
            PMT = Double((FV - (PV * pow((1 + I / CPY), CPY * N))) / ((pow((1 + I / CPY), CPY * N) - 1) / (I / CPY)) / (1 + I / CPY))
        }
        
        paymentValue = String(PMT.toFixed(2))
        
    }
    
    func findMissingFutureValue() -> Void {
        
        let PMT = Double(paymentValue)!
        let I = Double(interest)! / 100
        let PV = Double(presentValue)!
        let CPY = Double(compoundsPerYear)!
        let N = Double(noOfYears)!
        
        var FV: Double = 0
        
        if isBeginning {
            FV = PV * pow((1 + I / CPY), CPY * N) + (PMT * (pow((1 + I / CPY), CPY * N) - 1) / (I / CPY)) * (1 + I / CPY)
        } else {
            FV = PV * pow((1 + I / CPY), CPY * N) + (PMT * (pow((1 + I / CPY), CPY * N) - 1) / (I / CPY))
        }
        
        futureValue = String(FV.toFixed(2))
        
    }
    
    func findMissingNumberOfYears() -> Void {
        
        let FV = Double(futureValue)!
        let PV = Double(presentValue)!
        let PMT = Double(paymentValue)!
        let I = Double(interest)! / 100
        let CPY = Double(compoundsPerYear)!
        
        var N: Double = 0;
        
        if isBeginning {
            N = ((log(FV + PMT + ((PMT * CPY) / I)) - log(PV + PMT + ((PMT * CPY) / I))) / (CPY * log(1 + (I / CPY))))
        } else {
            N = Double((log(FV + ((PMT * CPY) / I)) - log(((I * PV) + (PMT * CPY)) / I)) / (CPY * log(1 + (I / CPY))))
        }
        
        if N.isNaN || N.isInfinite {
            noOfYears = "0"
        } else {
            noOfYears = String(N.toFixed(2))
        }
        
    }
    
    func loadSavedState() -> Void {
        
        let ud = UserDefaults.standard
        
        self.presentValue = ud.object(forKey: "dev.yazeen.fincal.savings.presentValue") as? String ?? ""
        self.interest = ud.object(forKey: "dev.yazeen.fincal.savings.interest") as? String ?? ""
        self.isBeginning = ud.object(forKey: "dev.yazeen.fincal.savings.isBeginning") as? Bool ?? false
        self.paymentValue = ud.object(forKey: "dev.yazeen.fincal.savings.paymentValue") as? String ?? ""
        self.compoundsPerYear = ud.object(forKey: "dev.yazeen.fincal.savings.compoundsPerYear") as? String ?? "12"
        self.futureValue = ud.object(forKey: "dev.yazeen.fincal.savings.futureValue") as? String ?? ""
        self.noOfYears = ud.object(forKey: "dev.yazeen.fincal.savings.noOfYears") as? String ?? ""
        
    }
    
    func persistCurrentState() -> Void {
        
        let ud = UserDefaults.standard
        
        ud.set(self.presentValue, forKey: "dev.yazeen.fincal.savings.presentValue")
        ud.set(self.interest, forKey: "dev.yazeen.fincal.savings.interest")
        ud.set(self.isBeginning, forKey: "dev.yazeen.fincal.savings.isBeginning")
        ud.set(self.paymentValue, forKey: "dev.yazeen.fincal.savings.paymentValue")
        ud.set(self.compoundsPerYear, forKey: "dev.yazeen.fincal.savings.compoundsPerYear")
        ud.set(self.futureValue, forKey: "dev.yazeen.fincal.savings.futureValue")
        ud.set(self.noOfYears, forKey: "dev.yazeen.fincal.savings.noOfYears")
        
    }
    
}
