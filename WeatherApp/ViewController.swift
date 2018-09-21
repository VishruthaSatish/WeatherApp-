//
//  ViewController.swift
//  WeatherApp
//
//  Created by MacStudent on 2018-03-27.
//  Copyright © 2018 MacStudent. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // -- MARK: Outlets
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    let session : URLSession = .shared
    
    // -- MARK: Actions
    @IBAction func weatherPressed(_ sender: Any) {
    
        /////------------ GETTING LOCATION
        
        // 1. get the location the user entered
        let location = locationLabel.text!
        
        // if person didn't enter something, then quit
        if (location.isEmpty == true) {
            print("hey, you gotta enter a location")
            locationLabel.text = "hey, enter a location"
            return
        }
        
        // 2. convert the location into coordinates (applemagically!)
        let geocoder = CLGeocoder()
        
        /*
            forward geolocation -> Location -> Coordinates
            reverse geolocation -> Coordinates -> Location
         */
 
        // a.  sending the location to apple
        geocoder.geocodeAddressString(location) { (placemarks, error)  in
            
            // b.  wait for apple to send you a response
            // deal with errors
            if let e = error {
                print("got an error while geocoding")
                return
            }
            
            // do something with the response
            // the coordinates come back from apple in a array called placemarks
            if placemarks!.count > 0 {
                let coord = placemarks![0].location
                print(coord!.coordinate.latitude)
                print(coord!.coordinate.longitude)
                
                var latitude = String(coord!.coordinate.latitude)
                var longitude = String(coord!.coordinate.longitude)
               
                // get the weather
                self.getWeather(lat:latitude, long:longitude)
                
            }
        }
    }
    
    
    // -- MARK: Weather Functions
    func getWeather(lat:String, long:String) {
        // url
        let url = URL(string:"https://api.darksky.net/forecast/ff41689fc242d7783a79fab7ae586b2b/\(lat),\(long)/?units=ca")
        
        // go visit the webpage and do soemthing with the results
        let task = session.dataTask(with: url!) { (data, response, error) in
            // 1. do something with the response (parse JSON)
            
            // a. check error
            if (error != nil) {
                print(error!.localizedDescription)
                return
            }
            
            // b. parse the json
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            if let dict = json as? [String:Any] {
                // parse your json
                // --------------------------------------------
                // get the "currently" dictionary
                let curr = dict["currently"] as! [String:Any]
                
                //  get the "temperature" field
                let temp = curr["temperature"] as! Double
                
                // get the "summary" field
                let summary = curr["summary"] as! String
                
                print(temp)
                print(summary)
                
                DispatchQueue.main.async {
                    self.weatherLabel.text = "\(temp)°C"
                    self.summaryLabel.text = summary
                }
            }
        }
        task.resume()
    }
    
    
    
    // -- MARK: Default Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

