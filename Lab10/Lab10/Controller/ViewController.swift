//
//  ViewController.swift
//  Lab10
//
//  Created by Yulia Raitsyna on 27.05.24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "AppIcon")
        
    }
    

}

