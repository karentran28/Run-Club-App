//
//  CountdownView.swift
//  Run Club
//
//  Created by Karen Tran on 2025-02-06.
//

import SwiftUI

struct CountdownView: View {
    @EnvironmentObject var runTracker: RunTracker
    @State var timer: Timer?
    @State var countdown = 3
    
    var body: some View {
        Text("\(countdown)")
            .font(.system(size: 256))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.yellow)
            .onAppear{
                setupCountDown()
            }
        
    }
    
    func setupCountDown() {
        // _ in ... is a closure that gets exectued every 1 second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if countdown <= 1 {
                timer?.invalidate()
                timer = nil
                runTracker.presentCountdown = false
            } else {
                countdown -= 1
            }
        }
    }
}

#Preview {
    CountdownView()
}
