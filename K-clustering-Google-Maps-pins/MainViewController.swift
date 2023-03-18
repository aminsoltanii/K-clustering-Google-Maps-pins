//
//  ViewController.swift
//  Task2
//
//  Created by seyedali hamedi on 3/18/23.
//

import UIKit
import GoogleMaps
class MainViewController: UIViewController {
    
    let places:[String] = ["Tehran","qom","hamedan","saveh","arak","karaj"]
    let coordinates:[(lat:Double,lon:Double)] = [(lat:35.7219,lon:51.3347),(lat:34.6416,lon:50.8746),(lat:34.7983,lon:48.5148),(lat:35.0240,lon:50.3549),(lat:34.0873,lon:49.7022),(lat:35.8439,lon:50.9715)]
    
    var firstMarkers:[GMSMarker] = []
    var generatedMarkes:[GMSMarker] = []
    
    var globalMap:GMSMapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        let camera = GMSCameraPosition.camera(withLatitude: 35.7219, longitude: 51.3347, zoom: 5 )
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.delegate = self
        
        globalMap = mapView
        
        view.addSubview(mapView)


        
        for i in 0...places.count-1 {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: coordinates[i].lat, longitude:  coordinates[i].lon)
            marker.title = places[i]
            marker.snippet = "Iran"
            marker.map = mapView
            firstMarkers.append(marker)
            
        }
        
        let results = AlgoClass.optimizingKClusterin(maximumIterations: 10, k: 3, data: coordinates)
        
        for arr in results{
            var meanLat = 0.0;
            var meanLon = 0.0;
            for coor in arr{
                meanLat += coor.0
                meanLon += coor.1
            }
            meanLat /= Double(arr.count)
            meanLon /= Double(arr.count)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: meanLat, longitude:  meanLon)
            marker.title = ""
            marker.snippet = ""
            marker.icon = GMSMarker.markerImage(with: UIColor.green)
            generatedMarkes.append(marker)
        }
        
    }
   
    func changeMarkers(zoomLevel:Float){
        if(zoomLevel < 6){
            for mark in firstMarkers {
                mark.map = nil
            }
            for mark in generatedMarkes {
                mark.map = globalMap
            }
        }else{
            for mark in firstMarkers {
                mark.map = globalMap
            }
            for mark in generatedMarkes {
                mark.map = nil
            }
        }
    }
    

    
}
extension MainViewController:GMSMapViewDelegate{

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        changeMarkers(zoomLevel:position.zoom)
    }
}
