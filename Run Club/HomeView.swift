//
//  HomeView.swift
//  Run Club
//
//  Created by Karen Tran on 2025-02-02.
//

import SwiftUI
import MapKit


class RunTracker: NSObject, ObservableObject {
    @Published var region = MKCoordinateRegion(center: .init(latitude: 49.2827, longitude: -123.1207), span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @Published var presentCountdown = false
    
    //Location Tracking
    // optional is used because we initialize locationManager in init, but might get denied location access permissions so could be a nil value
    private var locationManager: CLLocationManager?
    private var startLocation: CLLocation?
    private var lastLocation: CLLocation?
    
    override init() {
        // ensures NSObject setup gets initialized since we inherit
        super.init()
        
        Task {
            await MainActor.run {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.requestWhenInUseAuthorization()
                locationManager?.startUpdatingLocation()
            }
        }
    }
    
}

struct AreaMap: View {
    @Binding var region: MKCoordinateRegion
    
    var body: some View {
        let binding = Binding (
            get: { self.region },
            set: { newValue in
                DispatchQueue.main.async {
                    self.region = newValue
                }
            }
        )
        return Map(coordinateRegion: binding, showsUserLocation: true)
            .ignoresSafeArea()
    }
}

// MARK: Location Tracking
extension RunTracker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //location = current location
        guard let location = locations.last else { return }
        
        //once app is launched with permission granted, map should update to current user location
        Task {
            await MainActor.run {
                region.center = location.coordinate
            }
        }
        
        if startLocation == nil {
            startLocation = location
            lastLocation = location
            return
        }
        
        lastLocation = location
    }
}

struct HomeView: View {
    @StateObject var runTracker = RunTracker()
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .bottom) {
                    AreaMap(region: $runTracker.region)
                    
                    Button {
                        runTracker.presentCountdown = true
                    } label: {
                        Text("Start")
                            .bold()
                            .font(.title)
                            .foregroundStyle(.black)
                            .padding(36)
                            .background(.yellow)
                            .clipShape(Circle())
                    }
                    .padding(.bottom)
                }
                

            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("Run")
            .fullScreenCover(isPresented: $runTracker.presentCountdown, content: {
                CountdownView()
                    .environmentObject(runTracker)
            })
        }
    }
}

#Preview {
    HomeView()
}
