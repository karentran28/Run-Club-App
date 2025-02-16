//
//  RunTracker.swift
//  Run Club
//
//  Created by Karen Tran on 2025-02-16.
//

import Foundation
import MapKit

class RunTracker: NSObject, ObservableObject {
    @Published var region = MKCoordinateRegion(center: .init(latitude: 49.2827, longitude: -123.1207), span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @Published var isRunning = false
    @Published var presentCountdown = false
    @Published var presentRunView = false
    @Published var distance = 0.0
    @Published var pace = 0.0
    @Published var elapsedTime = 0
    
    private var timer: Timer?
    
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
    
    func startRun() {
        presentRunView = true
        isRunning = true
        startLocation = nil
        // starting new run, don't want any old information
        lastLocation = nil
        distance = 0.0
        pace = 0.0
        //weak self prevents a reference cycle that otherwise couldn't be deallocated
        //reference cycle:
        // self(view controller) references timer which references the closure which references self
        //weak self breaks the retain cycle by making self a weak reference
        //so when self is deallocated (user closes view), the guard will return and closure will not be executed
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.elapsedTime += 1
            if self.distance > 0 {
                // elapsed time is in seconds (seconds / 60) = minutes
                // distance is in meters (meters / 1000) = km
                // pace = minutes/km
                pace = (Double(self.elapsedTime) / 60) / (self.distance / 1000)
            }
        }
        locationManager?.startUpdatingLocation()
    }
    
    func resumeRun() {
        isRunning = true
        startLocation = nil
        lastLocation = nil
        distance = 0.0
        pace = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.elapsedTime += 1
            if self.distance > 0 {
                // elapsed time is in seconds (seconds / 60) = minutes
                // distance is in meters (meters / 1000) = km
                // pace = minutes/km
                pace = (Double(self.elapsedTime) / 60) / (self.distance / 1000)
            }
        }
        locationManager?.startUpdatingLocation()
    }
    
    func stopRun() {
        isRunning = false
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
        presentRunView = false
    }
    
    func pauseRun() {
        isRunning = false
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
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
        
        //update current location
        if startLocation == nil {
            startLocation = location
            lastLocation = location
            return
        }
        
        // if let is a conditional unwrapping mechanism used to safely unwrap optionals
        // code will only execute if lastLocation is not nil
        // adds the distance from difference of last location (that was updated) and current location
        if let lastLocation {
            distance += lastLocation.distance(from: location)
        }
        //last location is not the current location
        lastLocation = location
    }
}
