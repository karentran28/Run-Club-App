//
//  RunView.swift
//  Run Club
//
//  Created by Karen Tran on 2025-02-06.
//

import SwiftUI
import AudioToolbox

struct RunView: View {
    @EnvironmentObject var runTracker: RunTracker
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("\(runTracker.distance, specifier: "%.2f") m")
                        .font(.title3)
                        .bold()
                    Text("Distance")
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("BPM")
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("\(runTracker.pace, specifier: "%.2f") km/min")
                        .font(.title3)
                        .bold()
                    Text("Pace")
                }
                .frame(maxWidth: .infinity)
            }
            
            VStack {
                Text("\(runTracker.elapsedTime.convertDurationToString())")
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
                // used when button has multiple gestures (ex. tap, long tap)
                .simultaneousGesture(LongPressGesture().onEnded({ _ in
                    runTracker.stopRun()
                    AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
                    
                }))
                
                Button {
                    if runTracker.isRunning {
                        runTracker.pauseRun()
                    } else {
                        runTracker.resumeRun()
                    }
                } label: {
                    Image(systemName: runTracker.isRunning ? "pause.fill" : "play.fill")
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
        .environmentObject(RunTracker())
}
