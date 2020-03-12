//
//  Investment.swift
//  FinCal
//
//  Created by Yasin on 3/8/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

/// `ViewModel For:`
/// `Compound Savings without Regular Contributions (Fixed sum investment)`

import Foundation
import Combine

final class Investment: ObservableObject {
    
    /// Variables that are decorated using @Published allows the
    /// subscribers to get notified when its value got changed.
    @Published var presentValue: String = "" { didSet{checkValidity()} }
    @Published var interest: String = "" { didSet{checkValidity()} }
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
        var propCount = 0;
        if !presentValue.isEmpty && Double(presentValue) != 0 { propCount += 1 }
        if !interest.isEmpty { propCount += 1 }
        if !compoundsPerYear.isEmpty && Double(compoundsPerYear) != 0 { propCount += 1 }
        if !futureValue.isEmpty && Double(futureValue) != 0 { propCount += 1 }
        if !noOfYears.isEmpty && Double(noOfYears) != 0 { propCount += 1 }
        calculationsDisabled = propCount == 4 ? false : true
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
        
        if presentValue.isEmpty {
            self.findMissingPresentValue()
        } else if futureValue.isEmpty {
            self.findMissingFutureValue()
        } else if noOfYears.isEmpty {
            self.findMissingNumberOfPayments()
        } else {
            self.findMissingInterest()
        }
        
        persistCurrentState()
        
    }
    
    func findMissingPresentValue() -> Void {
        
        let FV = Double(futureValue)!
        let I = Double(interest)! / 100
        let N = Double(noOfYears)!
        let CPY = Double(compoundsPerYear)!
        let PV = Double(FV / pow(1 + (I / CPY), CPY * N))
        
        presentValue = String(PV.toFixed(2))
        
    }
    
    func findMissingFutureValue() -> Void {
        
        let PV = Double(presentValue)!
        let I = Double(interest)! / 100
        let N = Double(noOfYears)!
        let CPY = Double(compoundsPerYear)!
        let FV = Double(PV * (pow((1 + I / CPY), CPY * N)))
        
        futureValue = String(FV.toFixed(2))
        
    }
    
    func findMissingNumberOfPayments() -> Void {
        
        let PV = Double(presentValue)!
        let FV = Double(futureValue)!
        let I = Double(interest)! / 100
        let CPY = Double(compoundsPerYear)!
        let N = Double(log(FV / PV) / (CPY * log(1 + (I / CPY))))
        
        noOfYears = String(N.toFixed(2))
        
    }
    
    func findMissingInterest() -> Void {
        
        let PV = Double(presentValue)!
        let FV = Double(futureValue)!
        let CPY = Double(compoundsPerYear)!
        let N = Double(noOfYears)!
        let I = Double(CPY * (pow(FV / PV, (1 / (CPY * N))) - 1))
        
        interest = String((I * 100).toFixed(2))
        
    }
    
    func loadSavedState() -> Void {
         
         let ud = UserDefaults.standard
         
         self.presentValue = ud.object(forKey: "dev.yazeen.fincal.investment.presentValue") as? String ?? ""
         self.interest = ud.object(forKey: "dev.yazeen.fincal.investment.interest") as? String ?? ""
         self.compoundsPerYear = ud.object(forKey: "dev.yazeen.fincal.investment.compoundsPerYear") as? String ?? "12"
         self.futureValue = ud.object(forKey: "dev.yazeen.fincal.investment.futureValue") as? String ?? ""
         self.noOfYears = ud.object(forKey: "dev.yazeen.fincal.investment.noOfYears") as? String ?? ""
         
     }
     
     func persistCurrentState() -> Void {
         
         let ud = UserDefaults.standard
         
         ud.set(self.presentValue, forKey: "dev.yazeen.fincal.investment.presentValue")
         ud.set(self.interest, forKey: "dev.yazeen.fincal.investment.interest")
         ud.set(self.compoundsPerYear, forKey: "dev.yazeen.fincal.investment.compoundsPerYear")
         ud.set(self.futureValue, forKey: "dev.yazeen.fincal.investment.futureValue")
         ud.set(self.noOfYears, forKey: "dev.yazeen.fincal.investment.noOfYears")
         
     }
    
}
