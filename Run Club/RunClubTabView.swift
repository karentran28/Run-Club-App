//
//  RunClubTabView.swift
//  Run Club
//
//  Created by Karen Tran on 2025-02-06.
//

import SwiftUI

struct RunClubTabView: View {
    @State var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag(0)
                .tabItem {
                    Image(systemName: "figure.run")
                    Text("Run")
                }
            
            ActivityView()
                .tag(1)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Activity")
                }
        }
    }
}

#Preview {
    RunClubTabView()
}
