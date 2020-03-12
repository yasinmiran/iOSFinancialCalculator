//
//  HomeView.swift
//  FinCal
//
//  Created by Yasin on 3/3/20.
//  Copyright © 2020 Yasin. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        
        TabView {
            MortgageView().tabItem({
                Image("mortgage").resizable()
                Text("Mortgage")
            }).tag(0)
            SavingsView().tabItem({
                Image("c-savings").resizable()
                Text("Savings")
            }).tag(1)
            InvestmentView().tabItem({
                Image("c-savings-fs").resizable()
                Text("Investment")
            }).tag(2)
            LoanView().tabItem({
                Image("loans").resizable()
                Text("Loans")
            }).tag(3)
        }
    }
    
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
