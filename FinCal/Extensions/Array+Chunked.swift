//
//  Array+Chunked.swift
//  FinCal
//
//  Created by Yasin on 3/9/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import Foundation

extension Array {
    // Split array into chunks of n
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
