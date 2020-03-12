//
//  CustomVerticalSpacer.swift
//  FinCal
//
//  Created by Yasin on 3/5/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import SwiftUI

/*
 * @Stateless util widget
 */
struct CustomVerticalSpacer: View {
    
    let top: CGFloat;
    let bottom: CGFloat;
    
    var body: some View {
        Text("")
            .padding(.top, top)
            .padding(.bottom, bottom)
    }
    
}
