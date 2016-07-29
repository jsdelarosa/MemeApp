//
//  MemeDetailViewController.swift
//  testImagePicker
//
//  Created by Salvador De La Rosa on 7/28/16.
//  Copyright © 2016 Magnolia Inc. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
      
        imageView.image = meme.memedImage
    }
}