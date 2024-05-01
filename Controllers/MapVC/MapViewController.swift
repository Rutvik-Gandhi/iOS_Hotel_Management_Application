//
//  MapViewController.swift
//  My Hotels
//
//  Created by My Hotels on 08/12/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var objHotel: ModelHotel?
    
    
    //MARK: - View Controllers Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.setupMap()
        }
    }
    
    func setupMap() {
        
        let lat = objHotel?.geoLocation?.latitude ?? 0
        let long = objHotel?.geoLocation?.longitude ?? 0
        
        mapView.delegate = self
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        let annotation = MKPointAnnotation()
        annotation.title = objHotel?.name ?? ""
        annotation.subtitle = "Lat: \(lat), Long: \(long)"
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion( center: annotation.coordinate, latitudinalMeters: CLLocationDistance(exactly: 800)!, longitudinalMeters: CLLocationDistance(exactly: 800)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    
    //MARK: - UIMapView Delegates -
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation { return nil }

            let reuseIdentifier = "annotaion"

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let annotation = views.first(where: { $0.reuseIdentifier == "annotaion" })?.annotation {
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
}

//MARK: - Custom AnnotationView for map -

class CustomAnnotationView: MKPinAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
        rightCalloutAccessoryView = UIButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
