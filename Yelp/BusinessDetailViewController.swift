//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Aristotle on 2017-12-01.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class BusinessDetailViewController: UIViewController {

    var business: Business?
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!

    @IBOutlet weak var businessMapView: MKMapView!
    var coordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Translucent navigation bar
        if let navigationBar = navigationController?.navigationBar {
            print("setting navigation bar customization in detail view")
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.backgroundColor = .clear
            navigationBar.isTranslucent = true
        }
        
        if let business = business {
            businessImageView.setImageWith(business.imageURL!)
            nameLabel.text = business.name!
            ratingImageView.setImageWith(business.ratingImageURL!)
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            categoriesLabel.text = business.categories!
            print("COORD LONG IS 💗 \(String(describing: business.longitude)) and COORD LAT is \(String(describing: business.latitude))")
            coordinate = CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longitude!)
            addAnnotationAtCoordinate(coordinate: coordinate!)
            let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            businessMapView.region = MKCoordinateRegion(center: coordinate!, span: mapSpan)
        }
        
    }
    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = business?.name!
        businessMapView.addAnnotation(annotation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
