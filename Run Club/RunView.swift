//
//  RunView.swift
//  Run Club
//
//  Created by Karen Tran on 2025-02-06.
//

import SwiftUI

struct RunView: View {
    @EnvironmentObject var runTracker: RunTracker
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Distance")
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("BPM")
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("Pace")
                }
                .frame(maxWidth: .infinity)
            }
            
            VStack {
                Text("00:00")
                    .font(.system(size: 64))
                
                Text("Time")
                    .foregroundStyle(.gray)
            }
            .frame(maxHeight: .infinity)
            
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    
                } label: {
                    Image(systemName: "pause.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(.yellow)
    }
}

#Preview {
    RunView()
}
