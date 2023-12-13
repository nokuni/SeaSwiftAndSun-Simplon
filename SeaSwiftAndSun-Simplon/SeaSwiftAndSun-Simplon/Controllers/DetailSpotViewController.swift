//
//  DetailSpotViewController.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Amandine Cousin on 05/12/2023.
//

import UIKit

class DetailSpotViewController: UIViewController {
    @IBOutlet weak var spotImage: UIImageView!
    
    var spot: Fields?
    
    var surfBreakType: UILabel =  {
        let label = UILabel()
        label.text = "surf Break Type"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true

        return label
    }()
    
    var spotName: UILabel =  {
        let label = UILabel()
        label.text = "Spot Name"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var country: UILabel =  {
        let label = UILabel()
        label.text = "Country"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var seasonStart: UILabel =  {
        let label = UILabel()
        label.text = "Season Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var seasonEnd: UILabel =  {
        let label = UILabel()
        label.text = "Season End"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var difficultyLevel: UILabel =  {
        let label = UILabel()
        label.text = "Difficulty: "
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let spot = spot {
            seasonStart.text = "Season starts: \(spot.peakSurfSeasonBegins)"
            seasonEnd.text = "Season ends: \(spot.peakSurfSeasonEnds)"
            spotName.text = spot.destination
            country.text = spot.destinationStateCountry
            difficultyLevel.text = "Difficulty: \(spot.difficultyLevel)"
            surfBreakType.text = spot.surfBreak[0].rawValue
            if let url = getPictureURL(spot: spot) { spotImage.load(url: url) }
            
            
            switch surfBreakType.text {
            case "Beach Break" :
                surfBreakType.textColor = UIColor.black
                surfBreakType.backgroundColor = UIColor.init(red: 196/255, green: 236/255, blue: 255/255, alpha: 1.0)
            case "Reef Break" :
                surfBreakType.textColor = UIColor.black
                surfBreakType.backgroundColor = UIColor.init(red: 116/255, green: 235/255, blue: 225/255, alpha: 1.0)
            case "Point Break" :
                surfBreakType.textColor = UIColor.black
                surfBreakType.backgroundColor = UIColor.init(red: 196/255, green: 245/255, blue: 240/255, alpha: 1.0)
            case "Outer Banks" :
                surfBreakType.textColor = UIColor.white
                surfBreakType.backgroundColor = UIColor.init(red: 13/255, green: 82/255, blue: 172/255, alpha: 1.0)
            default:
                surfBreakType.textColor = UIColor.black
                surfBreakType.backgroundColor = UIColor.init(red: 196/255, green: 236/255, blue: 255/255, alpha: 1.0)
            }
        }
        
        setUpUI()
        setUpConstraints()
    }
    
    func getPictureURL(spot: Fields) -> URL? {
        guard let urlString = spot.photos.first?.url,
              let url = URL(string: urlString) else { return nil }
        return url
    }
    
    func setUpUI() {
        //        self.spotImage.layer.cornerRadius = self.spotImage.frame.size.width / 2
    }
    
    func setUpConstraints() {
        let stackView = UIStackView(arrangedSubviews: [surfBreakType, spotName, country, difficultyLevel, seasonStart, seasonEnd])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            stackView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -40),
            stackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, constant: -40)
        ])
    }
}
