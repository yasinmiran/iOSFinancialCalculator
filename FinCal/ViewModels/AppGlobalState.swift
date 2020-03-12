//
//  AppGlobalState.swift
//  FinCal
//
//  Created by Yasin on 3/10/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import Foundation
import Combine

class AppGlobalState: ObservableObject {
    
    @Published var hideTabBar: Bool = false
    
}
