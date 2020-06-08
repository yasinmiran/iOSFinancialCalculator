//
//  Double+FixedPoints.swift
//  FinCal
//
//  Created by Yasin on 3/8/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import Foundation

extension Double {
    func toFixed(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (divisor*self).rounded() / divisor
    }
}
