//
//  NewSpotViewController.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Tatiana Simmer on 13/12/2023.
//

import Foundation
import UIKit

class NewSpotViewController: UIViewController {
    var spot: Fields?
    let apiManager = APIManager()
    let url = "https://api.airtable.com/v0/appLwnyGpn1sS3QSc/Surf%20Destinations"
    let token = "patKTpR8A45bdjdCl.e09bf84bc75e3c079b6ceda4de5abe8a2ee4bda1a82c268f98cb4667494b20dd"

    let destinationName: StyledTextField = {
        let textField = StyledTextField()
        textField.label.text = "Destination Name"
        textField.text = "Nazare"
        textField.placeholder = "Ex: Nazare"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let countryState: StyledTextField = {
        let textField = StyledTextField()
        textField.label.text = "Country Name"
        textField.placeholder = "Ex: Portugal"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let peakSurfSeasonBegins: StyledTextField = {
        let textField = StyledTextField()
        textField.label.text = "Season Begins"
        textField.text = "2024-04-14"
        textField.placeholder = "Ex: 2024-04-14"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let peakSurfSeasonEnds: StyledTextField = {
        let textField = StyledTextField()
        textField.label.text = "Season Ends"
        textField.text = "2024-04-15"
        textField.placeholder = "Ex: 2024-04-15"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let difficultyLevel: StyledTextField = {
        let textField = StyledTextField()
        textField.label.text = "Difficulty"
        textField.text = "3"
        textField.placeholder = "Ex: 3"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let surfBreakType: StyledTextField = {
        let textField = StyledTextField()
        textField.label.text = "Break Type"
        textField.placeholder = "Ex: Beach Break"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let magicSeaweedLink: StyledTextField = {
        let textField = StyledTextField()
        textField.label.text = "Link"
        textField.placeholder = "Ex: http..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let photos: StyledTextField = {
        let textField = StyledTextField()       
        textField.label.text = "Photo"
        textField.placeholder = "Ex: http..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let address: StyledTextField = {
        let textField = StyledTextField()
        textField.label.text = "Address"
        textField.placeholder = "Ex: Manu Bay, Raglan, New Zealand"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let addNewSpotButton: StyledButton = {
        let button = StyledButton(type: .system)
        button.setTitle("Add a new spot", for: .normal)
        button.addTarget(self, action: #selector(addNewSpotButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add a new surfing spot"
        view.backgroundColor = .systemBackground
        setUpConstraints()
    }
    
    func setUpConstraints() {
        let stackView = UIStackView(arrangedSubviews: [destinationName, countryState, peakSurfSeasonBegins, peakSurfSeasonEnds, difficultyLevel, surfBreakType, magicSeaweedLink, photos, address, addNewSpotButton ])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    
    // objc functions can't be async
    //https://stackoverflow.com/questions/72349217/swift-concurrency-uibutton
    @objc func addNewSpotButtonTapped(_ sender: Any) {
        Task {
            try await postNewSpot()
        }
    }
    
    func postNewSpot() async throws {
        
        let destinationNameText = destinationName.text ?? ""
        let countryStateText = countryState.text ?? ""
        let peakSurfSeasonBeginsText = peakSurfSeasonBegins.text ?? ""
        let peakSurfSeasonEndsText = peakSurfSeasonEnds.text ?? ""
        let difficultyLevelText = difficultyLevel.text ?? ""
        let surfBreakTypeText = surfBreakType.text ?? ""
        let magicSeaweedLinkText = magicSeaweedLink.text ?? ""
        let photosText = photos.text ?? ""
        let addressText = address.text ?? ""
        
        let newSpotFields = Fields(
            peakSurfSeasonBegins: peakSurfSeasonBeginsText,
            destinationStateCountry: countryStateText,
            peakSurfSeasonEnds: peakSurfSeasonEndsText,
            difficultyLevel: Int(difficultyLevelText) ?? 0,
            destination: destinationNameText,
            surfBreak: [SurfBreak(rawValue: surfBreakTypeText) ?? .beachBreak],
            magicSeaweedLink: magicSeaweedLinkText,
            photos: [Photo(url: photosText)],
            address: nil,
            influencers: []
        )
        
        let records = [Record(fields: newSpotFields)]
        
        let recordData = RecordData(records: records)
        
        do {
            let _: RecordData = try await self.apiManager.post(
                url: url,
                token: token,
                value: recordData
            )
            dismiss(animated: true)
            
        } catch let error {
            throw error
        }
    }
}
