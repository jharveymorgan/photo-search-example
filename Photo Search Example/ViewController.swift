//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Jordan Harvey-Morgan on 7/23/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    // scroll view to display pics
    @IBOutlet weak var scrollView: UIScrollView!
    
    // create gray activity indicator
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    // create label for placholder text
    let placeholder = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*// add activity indicator to view
        view.addSubview(activityIndicatorView)
        // center activity indicator view
        activityIndicatorView.center = view.center
        // start animating when view loads
        activityIndicatorView.startAnimating() */
        
        view.addSubview(placeholder)
        placeholder.center = view.center
        placeholder.text = "Search Flickr"
        placeholder.adjustsFontSizeToFitWidth = true
        placeholder.textColor = UIColor.blackColor()
        
        // call function to search flickr
        //searchFlickrByHashtag("")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function search for photos using flickr api
    func searchFlickrByHashtag(searchString: String) {
        // width of screen for any device
        let imageWidth = self.view.frame.width
        
        // create variable to manage connection to internet via AFNetworking
        let manager = AFHTTPSessionManager()
        
        // create array to hold photo search parameters for flickr api
        let searchParameters = ["method": "flickr.photos.search",
                                "api_key": "22e56dce0d2e648fa83b2dce186082ac",
                                "format": "json",
                                "nojsoncallback": 1,
                                "text": searchString,
                                "extras": "url_m",
                                "per_page": 5]
        // use GET method to call flickr
        manager.GET("https://api.flickr.com/services/rest/",
                    parameters: searchParameters,
                    progress: nil,
                    success: { (operation: NSURLSessionDataTask, responseObject: AnyObject?) in
                        if let responseObject = responseObject {
                            
                            // print json information
                            print("Response: \(responseObject.description)")
                            
                            // parse JSON data from flickr api
                            let json = JSON(responseObject)
                            
                            // get url of photos
                            if let photos = json["photos"]["photo"].array {
                                //print("Number of Photos to Display: \(photos.count)")
                                
                                // set size of displayed images
                                self.scrollView.contentSize = CGSizeMake(imageWidth, imageWidth * CGFloat(photos.count))
                                
                                // for loop to get photos on page
                                for count in 0 ..< photos.count {
                                    // get urls of photos
                                    if let imageUrl = photos[count]["url_m"].string {
                                        
                                        // image view to display photo
                                        let imageView = UIImageView(frame: CGRectMake(0, imageWidth * CGFloat(count), imageWidth, imageWidth))
                                        // display each image as soon as it downloads from internet
                                        if let url = NSURL(string: imageUrl) {
                                            // get rid of activity indicator and placeholder text
                                            self.activityIndicatorView.removeFromSuperview()
                                            self.placeholder.removeFromSuperview()
                                            
                                            // add downloaded image to image view
                                            imageView.setImageWithURL(url)
                                            // display image view on screen by adding it to scroll view
                                            self.scrollView.addSubview(imageView)
                                        }
                                    }
                                } // end for  loop
                            }
                        }
            },
                    failure: { (operation: NSURLSessionDataTask?, error: NSError) in
                        // print error message
                        print("Error: \(error.localizedDescription)")
        })

        
    }
    
    // when search bar is tapped
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // remove all subviews for new search
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        // make keyboard go away when search button is tappped
        searchBar.resignFirstResponder()
        
        // show activity indicator
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        
        // get value of search bar
        if let searchText = searchBar.text {
            // search for photos based on user input
            searchFlickrByHashtag(searchText)
        }
    }


}

