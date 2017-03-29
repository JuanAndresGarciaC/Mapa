//
//  ViewController.swift
//  Mapa
//
//  Created by Juan Andres Garcia C on 24/03/17.
//  Copyright © 2017 Juan Andres Garcia C. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    var latitud = 0
    var longitud = 0
    var distotprev = 0
    var distanciaTotal = 0
    var locacioninicial = CLLocation()
    var locacion1 = CLLocation()
    var locacion2 = CLLocation()
    var actual = 0.0
    var zom = false
    
    @IBAction func TipoMapa(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            mapa.mapType = MKMapType.standard
        }else if sender.selectedSegmentIndex == 1{
            mapa.mapType = MKMapType.satellite
        }else if sender.selectedSegmentIndex == 2{
            mapa.mapType = MKMapType.hybrid
        }
    }
    
    @IBAction func Stepper(_ sender: UIStepper) {
        
        print(sender.stepValue)
        print(mapa.region.span.longitudeDelta)
        sender.maximumValue = 1
        sender.minimumValue = 0
                if actual == 0{
            actual = sender.value
        }
        /*
        if zom == false{
            zom = true
            mapa.region.span.longitudeDelta *= 0.5
        }else if zom == true{
            zom = false
            mapa.region.span.longitudeDelta *= 1.5
        }
        */
        if sender.value == 0 {
            mapa.region.span.longitudeDelta *= 1.5
           print("Sender:\(sender.value)")
            print("Span:\(mapa.region.span.longitudeDelta)")
        }else if sender.value == 1{
            mapa.isZoomEnabled = true
            mapa.region.span.latitudeDelta -= 10
            print("Sender:\(sender.value)")
            print("Span:\(mapa.region.span.longitudeDelta)")
        }
        
    }
    
    @IBAction func zm(_ sender: UIButton) {
        /*
        mapa.isZoomEnabled = true
        mapa.region.span.longitudeDelta *= 0.5
        mapa.region.span.latitudeDelta *= 0.5
 */
        var span : MKCoordinateSpan = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33, longitude: 44), span: span)
        mapa.setRegion(region, animated: true)
       
    }
    @IBAction func zom(_ sender: UIButton) {
        mapa.region.span.longitudeDelta = (mapa.region.span.longitudeDelta)/4
    }
    
    
    @IBOutlet weak var mapa: MKMapView!
    
    private let manejador = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    manejador.delegate = self
    manejador.desiredAccuracy = kCLLocationAccuracyBest
    manejador.requestWhenInUseAuthorization()
        var puntoA = CLLocationCoordinate2D()
        puntoA.latitude = CLLocationDegrees(latitud)
        puntoA.longitude = CLLocationDegrees(longitud)
    let pin = MKPointAnnotation()
    pin.title = "Posicion en grados:(\(longitud),\(latitud))"
    pin.subtitle = "Distancia Recorrida: \(distanciaTotal)"
    pin.coordinate = puntoA
    mapa.addAnnotation(pin)
    
        
    }
    
    
        
    
       
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        }else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        latitud = Int(manager.location!.coordinate.latitude)
        longitud = Int(manager.location!.coordinate.longitude)
        if distanciaTotal == 0{
            locacioninicial = manager.location!
            locacion1 = manager.location!
            distanciaTotal = 1
            distotprev = distanciaTotal
        }else{
            locacion2 = manager.location!
            
            distanciaTotal = distanciaTotal + Int(locacion1.distance(from: locacion2))
            //print("ditancia total: \(distanciaTotal)")
            //print("ditancia anterior: \(distotprev)")
            locacion1 = manager.location!
       
    }
    
        if distanciaTotal >= distotprev+50 {
            distotprev = distanciaTotal
            var puntoA = CLLocationCoordinate2D()
            puntoA.latitude = manager.location!.coordinate.latitude
            puntoA.longitude = manager.location!.coordinate.longitude
            let pin = MKPointAnnotation()
            print("Posicion en grados:(\(manager.location!.coordinate.latitude),\(manager.location!.coordinate.longitude))")
            latitud = Int(manager.location!.coordinate.latitude)
            longitud = Int(manager.location!.coordinate.latitude)
            pin.title = "Posicion en grados:(\(puntoA.latitude),\(puntoA.longitude))"
            print("locacion: \(puntoA.latitude), \(puntoA.longitude)")
            pin.subtitle = "Distancia Recorrida: \(distanciaTotal)"
            pin.coordinate = puntoA
            mapa.addAnnotation(pin)
            
        }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alerta = UIAlertController(title: "ERROR", message: "error \(error.localizedDescription)", preferredStyle: .alert)
        let accionOK = UIAlertAction(title: "OK", style: .default, handler: {accion in
            //...
        })
        alerta.addAction(accionOK)
        self.present(alerta, animated: true, completion: nil)
    }
}

}
