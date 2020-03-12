//
//  LoanAmortization.swift
//  FinCal
//
//  Created by Yasin on 3/9/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import Foundation

final class Amortization {
    
    var PA: Double
    var N: Double
    var I: Double
    var PMT: Double
    var type: AmortizationType
    
    init(principalAmount: Double, terms: Int, interest: Double, payment: Double, type: AmortizationType) {
        self.PA = principalAmount
        self.N = Double(terms)
        self.I = interest
        self.PMT = payment
        self.type = type
    }
    
    func amortize() -> AmortizationTable {
        
        var table: [MonthlyRecord] = [MonthlyRecord]() /// Amortization table
        var balance: Double = PA /// degrading balance
        var totalInterestPaid: Double = 0 /// total monthly interest
        
        let fixedEqual = balance / N
        let monthlyInterest: Double = I / 100 / 12
        
        for i in 1...Int(N) {
            
            let interest = balance * monthlyInterest
            let principal = type == .COMPOUND ? PMT - interest : fixedEqual
            balance = balance - principal
            
            table.append(MonthlyRecord(
                month: i,
                payment: type == .COMPOUND ? PMT : (principal + interest),
                principal: principal,
                interest: interest,
                balance: balance < 0 ? 0 : balance
            ))
            
            totalInterestPaid += interest
            
        }
        
        return AmortizationTable(
            rows: table.chunked(into: 12), // seperated by yearly
            totalInterest: totalInterestPaid // total interest for all
        )
        
    }
    
}

struct MonthlyRecord: Identifiable {
    
    var id = UUID()
    
    let month: Int
    let payment: Double
    let principal: Double
    let interest: Double
    let balance: Double
    
}

struct AmortizationTable {
    let rows: [[MonthlyRecord]]
    let totalInterest: Double
}

enum AmortizationType {
    case FIXED, COMPOUND
}
