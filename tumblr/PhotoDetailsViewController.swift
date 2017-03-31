//
//  PhotoDetailsViewController.swift
//  tumblr
//
//  Created by hollywoodno on 3/30/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoDetailsViewController: UIViewController {
    @IBOutlet weak var photoDetailsView: UIImageView!
    public var photoUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Displays image of selected cell coming from PhotoViewController
        photoDetailsView.setImageWith(photoUrl)
    }

}
