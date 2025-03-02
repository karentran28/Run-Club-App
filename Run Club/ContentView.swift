//
//  ContentView.swift
//  Run Club
//
//  Created by Karen Tran on 2025-02-02.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if let session = AuthService.shared.currentSession {
            RunClubTabView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
