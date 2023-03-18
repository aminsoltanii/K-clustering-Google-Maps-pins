//
//  ViewController.swift
//  K-clustering-Google-Maps-pins
//
//  Created by seyedali hamedi on 3/18/23.
//

import UIKit
 import GoogleMaps
class MainViewController: UIViewController {
    
    
    
    let places:[String] = ["Tehran","qom","hamedan","saveh","arak","karaj"]
    let latitudes = [35.7219,34.6416,34.7983,35.0240,34.0873,35.8439]
    let longitudes = [51.3347,50.8746,48.5148,50.3549,49.7022,50.9715]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 35.7219, longitude: 51.3347, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        view.addSubview(mapView)
        
        
        for i in 0...places.count-1 {
            var marker1 = GMSMarker()
            marker1.position = CLLocationCoordinate2D(latitude: latitudes[i], longitude:  longitudes[i])
            marker1.title = places[i]
            marker1.snippet = "Iran"
            marker1.map = mapView
        }
    }
}

