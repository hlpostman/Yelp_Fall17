//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class BusinessesViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeBetweenMapAndListViewsButton: UIBarButtonItem!
    var isMapView = false
    var isMoreDataLoading = false
    var businesses: [Business]!
    var searchedBusinesses: [Business]?
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Search bar
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search..."
        navigationItem.titleView = searchBar
        if let navigationBar = navigationController?.navigationBar {
            
            navigationBar.barTintColor = UIColor(red: 0.7, green: 0.03, blue: 0.03, alpha: 1)
            
        }

        // Search bar and map/list button vertical alignment
        //  To do (nav bar item alignment - elminated solutions commented out below, delete comments on successful implementation)
        changeBetweenMapAndListViewsButton.tintColor = .white
        //  changeBetweenMapAndListViewsButton.setTitlePositionAdjustment(.init(horizontal: 10, vertical: 20), for: .default)
        // changeBetweenMapAndListViewsButton.setBackgroundVerticalPositionAdjustment(100, for: .default)
        
        // Filter results loaded
        Business.searchWithTerm(term: "Pizza", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.searchedBusinesses = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )

    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return searchedBusinesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        // protect for nil businesses list?
        if searchedBusinesses != nil {
            print("returning searched business")
            cell.business = searchedBusinesses![indexPath.row]
        } else {
            print("searched businesses was nil")
            cell.business = businesses[indexPath.row]
        }
            return cell
    }
    
    func addAnnotationAtCoordinate(business: Business?) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: business!.latitude!, longitude: business!.longitude!)
        annotation.title = business?.name!
        mapView.addAnnotation(annotation)
    }

    
    @IBAction func onChangeBetweenMapAndListView(_ sender: Any) {
        
        if !isMapView {
            for business in searchedBusinesses! {
                addAnnotationAtCoordinate(business: business)
            }
        }
        
        let fromView = isMapView ? mapView : tableView
        let toView = isMapView ? tableView : mapView
        let transition: UIViewAnimationOptions = isMapView ? .transitionFlipFromLeft : .transitionFlipFromRight
        
        UIView.transition(from: fromView, to: toView, duration: 0.7, options:[.showHideTransitionViews, transition])
        isMapView = !isMapView
        changeBetweenMapAndListViewsButton.title = isMapView ? "List" : "Map"

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Entered scrollViewDidScroll")
        if !isMoreDataLoading {
            // Calculate the position of one screen length before the bottom of results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollViewOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start refreshing
//            print(sc)
//            if scrollView.contentOffset.y > scrollViewOffsetThreshold && tableView.isDragging {
            if scrollView.contentOffset.y > scrollViewOffsetThreshold && tableView.isDragging {
                print("scrollview.contentOffset.y > scrollViewOffsetThreshold && tableView.isDraggin")
                isMoreDataLoading = true
//                loadMoreData()
                Business.searchWithTerm(term: "Pizza", completion: { (businesses: [Business]?, error: Error?) -> Void in
                    
                    self.isMoreDataLoading = false
                    self.businesses = businesses
                    self.searchedBusinesses = businesses
                    self.tableView.reloadData()
                    if let businesses = businesses {
                        for business in businesses {
                            print(business.name!)
                            print(business.address!)
                        }
                    }
                    
                }
                )
                
            }
            
        }
    }
    
    /* Example of Yelp search with more search options specified
     Business.searchWithTerm("Restaurants", sort: .distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: Error!) -> Void in
     self.businesses = businesses
     
     for business in businesses {
     print(business.name!)
     print(business.address!)
     }
     }
     */

//    func loadMoreData() {
//        // Configure session so that completion handler is handled on Main UI thread
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
//        let task = session.data
//    }
    
    func extractKeywords(text: String) -> [String] {
        var keywords: [String]
        keywords = text.components(separatedBy: " ")
        let doNotMatch =  ["a":1, "an":1, "and":1, "at":1, "by":1, "for":1, "if":1, "in":1, "it":1, "of":1, "on":1, "or":1, "the":1, "with":1]
        for (index, word) in keywords[1..<keywords.count].enumerated() {
            // If one of the words is on the doNotMatch list remove it
            print(index, word)
            if (doNotMatch[word.lowercased()] != nil) && (index + 1 < keywords.count) {
                keywords.remove(at: index + 1)
                print(keywords)
                break
            }
        }
            return keywords
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Called searchBar()")
        if searchText.isEmpty {
            searchedBusinesses = self.businesses
            tableView.reloadData()
            print("searchText  is empty.  Reloaded data")
        } else {
            searchedBusinesses = businesses.filter({ (dataItem: Business) -> Bool in
                let keySearchWords = extractKeywords(text: searchText)
                for word in keySearchWords {
                    // Search by business name OR business type
                    if dataItem.name!.lowercased().contains(word.lowercased()) || dataItem.categories!.lowercased().contains(word.lowercased()){
                        print("Search text: \(searchText) and dataItem: \(dataItem.name!) TRUE")
                        return true
                    }
                }
                print("Search text: \(searchText) and dataItem: \(dataItem.name!) FALSE")
                return false
            })
        }
        tableView.reloadData()
        print("SearchBar() reloaded data at end of function")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! BusinessDetailViewController
        let cell = sender as! BusinessCell
        let indexPath = tableView.indexPath(for: cell)
        
        let business = searchedBusinesses![indexPath!.row]
        vc.business = business
     }
 
    
}
