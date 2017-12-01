//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business]!
    var searchedBusinesses: [Business]?
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "Yelp"
        
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
             cell.business = searchedBusinesses![indexPath.row]
            
            return cell
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
