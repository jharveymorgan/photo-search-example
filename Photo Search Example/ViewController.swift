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

    override func viewDidLoad() {
        super.viewDidLoad()
        // create gray activity indicator
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        // add activity indicator to view
        scrollView.addSubview(activityIndicatorView)
        // center activity indicator view
        activityIndicatorView.center = scrollView.center
        // start animating when view loads
        activityIndicatorView.startAnimating()
        
        // create variable to manage connection to internet via AFNetworking
        let manager = AFHTTPSessionManager()
        
        // create array to hold photo search parameters for flickr api
        let searchParameters = ["method": "flickr.photos.search",
                                "api_key": "22e56dce0d2e648fa83b2dce186082ac",
                                "format": "json",
                                "nojsoncallback": 1,
                                "text": "pug",
                                "extras": "url_m",
                                "per_page": 5]
        // use GET method to call flickr
        manager.GET("https://api.flickr.com/services/rest/",
                    parameters: searchParameters,
                    progress: nil,
                    success: { (operation: NSURLSessionDataTask, responseObject: AnyObject?) in
                        if let responseObject = responseObject {
                            // create empty array to hold urls of photos
                            var photoUrl = [String]()
                            
                            // print json information
                            print("Response: \(responseObject.description)")
                            
                            // parse JSON data from flickr api
                            let json = JSON(responseObject)
                            
                            // get url of photos
                            if let photos = json["photos"]["photo"].array {
                                print("Number of Photos to Display: \(photos.count)")
                                // set size of displayed images
                                self.scrollView.contentSize = CGSizeMake(320, 320 * CGFloat(photos.count))
                                
                                // for loop to get photos on page
                                for count in 0 ..< photos.count {
                                    // get urls of photos
                                    if let imageUrl = photos[count]["url_m"].string {
                                        // add url to array
                                        photoUrl.append(imageUrl)
                                        
                                        // image view to display photo
                                        let imageView = UIImageView(frame: CGRectMake(0, 320 * CGFloat(count), 320, 320))
                                        // display each image as soon as it downloads from internet
                                        if let url = NSURL(string: imageUrl) {
                                            // get rid of activity indicator after the image loads
                                            activityIndicatorView.removeFromSuperview()
                                            // add downloaded image to image view
                                            imageView.setImageWithURL(url)
                                            // display image view on screen by adding it to scroll view
                                            self.scrollView.addSubview(imageView)
                                        }
                                        
                                        
                                        /*// get image data from url, returns an optional
                                        let imageData = NSData(contentsOfURL: NSURL(string: imageUrl)!)
                                        // unwrap the image's data
                                        if let unwrappedImageData = imageData {
                                            // image view to display photo
                                            let imageView = UIImageView(image: UIImage(data: unwrappedImageData))
                                            imageView.frame = CGRect(x: 0, y: 320 * CGFloat(count), width: 320, height: 320)
                                            // display image image view
                                            self.scrollView.addSubview(imageView)
                                        } */
                                    }
                                } // end for  loop
                                
                                // print list of photo urls
                                print("Photo Urls: \(photoUrl)")
                            }
                        }
            },
                    failure: { (operation: NSURLSessionDataTask?, error: NSError) in
                        // print error message
                        print("Error: \(error.localizedDescription)")
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

