//
//  PhotosViewController.swift
//  tumblr
//
//  Created by hollywoodno on 3/30/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var posts: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 240
        
        // allow table view to be fed data and controlled by this view controller
        tableView.dataSource = self
        tableView.delegate = self

    //Mark: Network Request
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        // update table view with return network data
                        self.tableView.reloadData()
                    }
                }
        });
        task.resume()
        
    }
    
    //Mark: Construct table view and rows

    // 1 of 2 required method by UITableViewDataSource Protocol
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    // 2 of 2 required method by UITableViewDataSource Protocol
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // PhotoTableView cell will be the default cell for every cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoTableViewCell
        
        // Each cell will contain a post
        let post = posts[indexPath.row]
        
        // Use .value() to traverse the post and it's nested dics for the 'photos' key if it exist
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            if let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String {
                let imageUrl = URL(string: imageUrlString)!
                cell.photoImageView.setImageWith(imageUrl)
            } else {
                print("No image url")
            }
        } else {
            print("Photos is nil")
        }
        
        return cell
    }
    
    
    //Mark: Segue to details view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhotoDetailsViewController
        
        // index path is [Col, Row]
        let indexPath = tableView.indexPath(for: sender as! PhotoTableViewCell)!
        
        // IndexPath.row what row/cell are we on
        let post = posts[indexPath.row]
        
        // Prep image from selected cell to be sent to destination view controller
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            if let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String {
                let imageUrl = URL(string: imageUrlString)!
                vc.photoUrl = imageUrl
            } else {
                print("No image url")
            }
        } else {
            print("Photos is nil")
        }
    }
}
