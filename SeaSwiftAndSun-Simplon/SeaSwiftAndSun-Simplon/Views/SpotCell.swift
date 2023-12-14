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
    @IBOutlet weak var spotLocation: UILabel!
    @IBOutlet weak var spotDifficulty: UILabel!
    
    func pictureURL(field: Fields) -> URL? {
        guard let urlString = field.photos?.first?.url,
              let url = URL(string: urlString) else { return nil }
        return url
    }
    
    func setUpCell(field: Fields) {
        spotName.text = field.destination
        spotLocation.text = field.destinationStateCountry
        if let url = pictureURL(field: field) { spotImage.load(url: url) }
        spotImage.layer.cornerRadius = spotImage.frame.size.width / 2
        spotDifficulty.text = "\(field.difficultyLevel)"
    }
}
