//
//  DetailSpotViewController.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Amandine Cousin on 05/12/2023.
//

import UIKit

class DetailSpotViewController: UIViewController {
    @IBOutlet weak var spotImage: UIImageView!
    var starContainer = UIStackView()
    var spot: Fields?
    var magicLinkButton: UIButton?
    
    var surfBreakType: UILabel =  {
        let label = UILabel()
        label.text = "surf Break Type"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var country: UILabel =  {
        let label = UILabel()
        label.text = "Country"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var seasonStart: UILabel =  {
        let label = UILabel()
        label.text = "Season Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var seasonEnd: UILabel =  {
        let label = UILabel()
        label.text = "Season End"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var difficultyLevel: UILabel =  {
        let label = UILabel()
        label.text = "Difficulty: "
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        if let spot = spot {
            
            let formattedStartDate = DateFormatter.formattedDateFromString(spot.peakSurfSeasonBegins)
            let formattedEndDate = DateFormatter.formattedDateFromString(spot.peakSurfSeasonEnds)
            
            seasonStart.text = "Season starts: \(formattedStartDate)"
            seasonEnd.text = "Season ends: \(formattedEndDate)"
            spotName.text = spot.destination
            country.text = spot.destinationStateCountry
            addDifficultyStars(difficultyLevel: spot.difficultyLevel)
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
        setupMagicLinkButton()
        setUpConstraints()
    }
}

//MARK: extension of the DetailVC:

extension DetailSpotViewController {

    //MARK: We set up our Link Button
    func setupMagicLinkButton() {
        magicLinkButton = UIButton(type: .system)
        magicLinkButton?.setTitle("🌊 See more", for: .normal)
        magicLinkButton?.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 22)
        magicLinkButton?.setTitleColor(UIColor.init(red: 13/255, green: 82/255, blue: 172/255, alpha: 1.0), for: .normal)
        magicLinkButton?.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        magicLinkButton?.translatesAutoresizingMaskIntoConstraints = false
    }

    //MARK: When button tapped we do this👇
    @objc func linkButtonTapped() {
        guard let magicSeaweedLink = spot?.magicSeaweedLink,
              let url = URL(string: magicSeaweedLink) else {
            return
        }
        UIApplication.shared.open(url)
    }

    //MARK: To get Picture URL 👇
    func getPictureURL(spot: Fields) -> URL? {
        guard let urlString = spot.photos?.first?.url,
              let url = URL(string: urlString) else { return nil }
        return url
    }

    //MARK: To add stars for diff lvl ⭐️
    func addDifficultyStars(difficultyLevel: Int) {
        let starSize: CGFloat = 20
        let spacing: CGFloat = 5
        let starCount = difficultyLevel
        starContainer.axis = .horizontal
        starContainer.alignment = .fill
        starContainer.distribution = .fillEqually
        starContainer.spacing = spacing
        starContainer.translatesAutoresizingMaskIntoConstraints = false
        
        for _ in 0..<starCount {
            let starSymbol = UIImage(systemName: "star.fill")
            let starImageView = UIImageView(image: starSymbol)
            starImageView.contentMode = .scaleAspectFit
            starImageView.tintColor = UIColor.init(red: 255/255, green: 172/255, blue: 28/255, alpha: 1.0)
            starContainer.addArrangedSubview(starImageView)
            starImageView.widthAnchor.constraint(equalToConstant: starSize).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: starSize).isActive = true
        }
    }

    //MARK: Set up Constrains for the view
    func setUpConstraints() {
        let horizontalStackView = UIStackView(arrangedSubviews: [difficultyLevel, starContainer])
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 10
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalStackView = UIStackView(arrangedSubviews: [spotName, country, horizontalStackView, seasonStart, seasonEnd])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.spacing = 10
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        if let magicLinkButton = magicLinkButton {
            verticalStackView.addArrangedSubview(magicLinkButton)
        }
        
        view.addSubview(verticalStackView)
        view.addSubview(surfBreakType)
        
        NSLayoutConstraint.activate([
            surfBreakType.widthAnchor.constraint(equalToConstant: 150),
            surfBreakType.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            surfBreakType.topAnchor.constraint(equalTo: spotImage.bottomAnchor, constant: 30),
            
            verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150),
            verticalStackView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -40),
            verticalStackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, constant: -40)
        ])
    }
}

extension DateFormatter {
    static func formattedDateFromString(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }
}
