//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Jordan Harvey-Morgan on 7/23/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // create variable to manage connection to internet via AFNetworking
        let manager = AFHTTPSessionManager()
        
        // create array to hold photo search parameters for flickr api
        let searchParameters = [ "method": "flicker.photos.search",
                                 "api_key": "22e56dce0d2e648fa83b2dce186082ac",
                                 "format": "json",
                                 "nojsoncallback": 1,
                                 "text": "dogs",
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

