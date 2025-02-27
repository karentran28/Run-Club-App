//
//  PauseView.swift
//  Run Club
//
//  Created by Karen Tran on 2025-02-16.
//

import SwiftUI
import MapKit
import AudioToolbox

struct PauseView: View {
    @EnvironmentObject var runTracker: RunTracker
    
    var body: some View {
        VStack {
            AreaMap(region: $runTracker.region)
                .ignoresSafeArea()
                .frame(height: 300)
            
            HStack {
                VStack {
                    Text("\(runTracker.distance / 1000, specifier: "%.2f")")
                        .font(.title3)
                        .bold()
                    
                    Text("Km")
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("\(runTracker.pace, specifier: "%.2f") km/min")
                        .font(.title3)
                        .bold()
                    Text("Avg Pace")
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("\(runTracker.elapsedTime.convertDurationToString())")
                        .font(.title3)
                        .bold()
                    Text("Time")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
           
            HStack {
                VStack {
                    Text("0.00")
                        .font(.title3)
                        .bold()
                    
                    Text("Calories")
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("0.00")
                        .font(.title3)
                        .bold()
                    Text("Elevation")
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("0.00")
                        .font(.title3)
                        .bold()
                    Text("BPM")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            
            HStack {
                Button {
                    // no action on tap of stop button
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
                // used when button has multiple gestures (ex. tap, long tap)
                .simultaneousGesture(LongPressGesture().onEnded({ _ in
                    withAnimation {
                        runTracker.stopRun()
                        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                    }
                }))
                
                Button {
                    runTracker.resumeRun()
                } label: {
                    Image(systemName: "play.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    PauseView()
        .environmentObject(RunTracker())
}
