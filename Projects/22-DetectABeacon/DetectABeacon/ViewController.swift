//
//  ViewController.swift
//  DetectABeacon
//
//  Created by JC on 18/9/21.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var circle: UIView! // Challenge 3 of instructor
    @IBOutlet var identierLabel: UILabel! // Challenge 2 of instructor
    @IBOutlet var distanceLabel: UILabel!
    
    var locationManager: CLLocationManager?
    var hasBeenShown = false // Challenge 1 of instructor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circle.layer.cornerRadius = 128
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        // Requests permission (authorization in iOS) to use the location ALWAYS
        locationManager?.requestAlwaysAuthorization()
        // If we want to use the location only while in use, we should use:
        // locationManager?.requestWhenInUseAuthorization()
        
        // If our posistion is unknown
        view.backgroundColor = .gray
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                // Meaning: Can we detect how far away a beacon is compared to us?
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }

    /**
     We set the UUID of a iBeacon that we already know what UUID it will have, so if we approach
     some other beacon with another UUID towards the device, it won't be recognized.
     
     - UUID: You're in a Acme Hardware Supplies Store
     - Major: You're in the Glasgow branch
     - Minor: You're in the show department of the third floor
     
     If you don't need that level of detail, you can skip minor and/or major
     */
    func startScanning() {
        var beacons = [CLBeaconRegion]()
        
        beacons.append(
            CLBeaconRegion(
                proximityUUID: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!,
                major: 123,
                minor: 456,
                identifier: "MyBeacon1"
            )
        )
        
        // Challenge 2 of instructor
        // NOTE: We have to add these UUIDs to the Detect Beacon app in order to being able to be recognized.
        beacons.append(
            CLBeaconRegion(
                proximityUUID: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E6")!,
                major: 456,
                minor: 789,
                identifier: "MyBeacon2")
        )
        beacons.append(
            CLBeaconRegion(
                proximityUUID: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E7")!,
                major: 654,
                minor: 321,
                identifier: "MyBeacon3")
        )
        
        for beacon in beacons {
            locationManager?.startMonitoring(for: beacon)
            locationManager?.startRangingBeacons(in: beacon)
        }
    }
    
    func update(distance: CLProximity, beaconIdentifier: String) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.setDistance(
                    transform: CGAffineTransform(scaleX: 0.25, y: 0.25),
                    color: .blue,
                    distance: "Far"
                )
                
            case .near:
                self.setDistance(
                    transform: CGAffineTransform(scaleX: 0.5, y: 0.5),
                    color: .orange,
                    distance: "Near"
                )
                
            case .immediate:
                self.setDistance(
                    transform: CGAffineTransform(scaleX: 1, y: 1),
                    color: .red,
                    distance: "Right here"
                )
                
            default:
                self.setDistance(
                    transform: CGAffineTransform(scaleX: 0.001, y: 0.001),
                    color: .gray,
                    distance: "Unknown"
                )
            }
            self.identierLabel.text = beaconIdentifier // Challenge 2 of instructor
        }
    }
    
    func setDistance(transform: CGAffineTransform, color: UIColor, distance: String) {
        self.circle.transform = transform // Challenge 3 of instructor
        self.view.backgroundColor = color
        self.distanceLabel.text = distance
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didRangeBeacons beacons: [CLBeacon],
        in region: CLBeaconRegion
    ) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity, beaconIdentifier: beacon.description)
            // Challenge 1 of instructor
            if !hasBeenShown {
                showAlertController()
                hasBeenShown = true
            }
        } else {
            update(distance: .unknown, beaconIdentifier: "Unknown")
        }
        
    }
    
    // Challenge 1 of instructor
    func showAlertController() {
        let ac = UIAlertController(
            title: "A wild beacon appeared!",
            message: "For the first time",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
}
