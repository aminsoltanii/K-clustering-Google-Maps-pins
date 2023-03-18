//
//  ViewController.swift
//  Task2
//
//  Created by seyedali hamedi on 3/18/23.
//

import UIKit
import GoogleMaps
class MainViewController: UIViewController {
    
    let places:[String] = ["pin1","pin2","pin3","pin4","pin5","pin6","pin7","pin8","pin9","pin10"]
    let coordinates:[(lat:Double,lon:Double)] = [(lat:35.7000,lon:51.3000),(lat:35.7100,lon:51.3000),(lat:35.6900,lon:51.3000),(lat:35.7100,lon:51.3100),(lat:35.7100,lon:51.2900),(lat:35.6900,lon:51.3100),(lat:35.7050,lon:51.3050),(lat:35.6950,lon:51.3050),(lat:35.7070,lon:51.2900),(lat:35.7200,lon:51.3000)]
    
    var firstMarkers:[GMSMarker] = []
    var generatedMarkes:[GMSMarker] = []
    
    var globalMap:GMSMapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        let camera = GMSCameraPosition.camera(withLatitude: 35.7219, longitude: 51.3347, zoom: 10 )
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
        if(zoomLevel < 11.5){
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
