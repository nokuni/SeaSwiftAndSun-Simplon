//
//  SpotCell.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Amandine Cousin on 05/12/2023.
//

import UIKit

class SpotCell: UITableViewCell {
    @IBOutlet weak var spotImage: UIImageView!
    @IBOutlet weak var spotName: UILabel!
    
    func setUpCell(){
        self.spotImage.image = UIImage(named: "surfSpot")
        self.spotImage.layer.cornerRadius = self.spotImage.frame.size.width / 2
    }
}
