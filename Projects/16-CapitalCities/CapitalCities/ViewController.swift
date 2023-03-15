//
//  ViewController.swift
//  CapitalCities
//
//  Created by JC on 12/9/21.
//

import MapKit
import UIKit
import WebKit

/**
 NOTE: It's required to hold CONTROL key on the Main.storyboard and drag the MapView to the
 ViewController and check the "delegate" option.
 */
class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var capitals = [Capital]()
        
        capitals.append(Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics"))
        capitals.append(Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago"))
        capitals.append(Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light"))
        capitals.append(Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it."))
        capitals.append(Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself."))
        
        // This only adds the icon, not the information label
        for capital in capitals {
            mapView.addAnnotation(capital)
        }
        
        // Challenge of instructor
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(changeMapType))
    }

    /**
     An annotation view works like a table view cell or a collection view cell. iOS reuses annotations
     to make best use of memory. This method will be responsible of assigning details to an
     annotation and of creating one if there isn't a dequeued one yet.
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        /**
         This way, we avoid showing annotations that isn't ours. For example, if we enable tracking
         the user's location, then it will be showed as an annotation, which is not a Capital.
         */
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        // If it's the first annotation, then we set it up
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            /**
             If we set canShowCallout to true, then when we tap on an annotation, a popup will
             appear showing the information of the annotation. In this case, it will show the name
             of the capital.
             */
            annotationView?.canShowCallout = true
            
            // Challenge of the instructor
            annotationView?.pinTintColor = UIColor(red: 0.5, green: 1, blue: 0.5, alpha: 1)
            //
            
            let btn = UIButton(type: .detailDisclosure)
            
            /**
             Adds the button to the annotation. It will appear as a blue (i) because of
             .detailDisclosure
             */
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            // Loading a new capital into the annotation
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    // Triggered when tapping on the annotation popup
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard let capital = view.annotation as? Capital else { return }
        
        // Challenge of instructor
        let detailViewController = DetailViewController()
        detailViewController.capitalName = capital.title
        navigationController?.pushViewController(detailViewController, animated: true)
        //
        
        /** Replaced by the code above
        let alertController = UIAlertController(title: capital.title, message: capital.info, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
         */
    }
    
    // Challenge of instructor
    @objc func changeMapType() {
        let alertController = UIAlertController(title: "Change map type", message: "", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Satellite", style: .default) {_ in
            self.mapView.mapType = .satellite
        })
        alertController.addAction(UIAlertAction(title: "Standard", style: .default) {_ in
            self.mapView.mapType = .standard
        })
        alertController.addAction(UIAlertAction(title: "Hybrid", style: .default) {_ in
            self.mapView.mapType = .hybrid
        })
        
        present(alertController, animated: true)
    }
    
}
