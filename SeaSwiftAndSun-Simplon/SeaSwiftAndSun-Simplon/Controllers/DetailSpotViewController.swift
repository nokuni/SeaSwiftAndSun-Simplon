//
//  DetailSpotViewController.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Amandine Cousin on 05/12/2023.
//

import UIKit

class DetailSpotViewController: UIViewController {
    @IBOutlet weak var spotImage: UIImageView!
    @IBOutlet weak var spotName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
    }
    
    func setUpUI() {
        self.spotImage.layer.cornerRadius = self.spotImage.frame.size.width / 2
    }
}
