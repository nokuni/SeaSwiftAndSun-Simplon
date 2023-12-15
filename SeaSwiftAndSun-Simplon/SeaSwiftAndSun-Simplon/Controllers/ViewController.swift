//
//  ViewController.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Amandine Cousin on 05/12/2023.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var mapView: UIView?
    
    let apiManager = APIManager()
    let url = "https://api.airtable.com/v0/appLwnyGpn1sS3QSc/Surf%20Destinations"
    let token = "patKTpR8A45bdjdCl.e09bf84bc75e3c079b6ceda4de5abe8a2ee4bda1a82c268f98cb4667494b20dd"
    var records = [Record]()
    
    var currentDisplay: ViewDisplay = .list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(title: "Add", 
                                        style: .plain,
                                        target: self,
                                        action: #selector(addButtonTapped))
        addButton.tintColor = UIColor(Color.accentColor)
        navigationItem.rightBarButtonItem = addButton

        self.title = "Liste des spots de surf"
        segmentedControl.addTarget(self, action: #selector(switchDisplay), for: .valueChanged)
        loadData()
    }
    
    func loadData() {
        DispatchQueue.main.async {
            Task {
                let data: RecordData = try await self.apiManager.get(url: self.url, token: self.token)
                let records = data.records
                self.records = records
                self.tableView.reloadData()
                self.setupMap()
            }
        }
    }
    
    var fields: [Fields] { records.map(\.fields) }
    
    func surfbreaks(category: SurfBreak) -> [Fields] {
        fields.filter {
            $0.surfBreak.contains(category)
        }
    }
    
    func getSectionFields(section: Int) -> [Fields] {
        switch section {
        case 1:
            surfbreaks(category: .beachBreak)
        case 2:
            surfbreaks(category: .reefBreak)
        case 3:
            surfbreaks(category: .pointBreak)
        default:
            surfbreaks(category: .outerBanks)
        }
    }

    @objc func addButtonTapped() {
        let addSpotViewController = NewSpotViewController()
        present(addSpotViewController, animated: true, completion: nil)
    }
}


//MARK: Handle Data source and delegate of tableview
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return SurfBreak.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return SurfBreak.beachBreak.rawValue
        case 2:
            return SurfBreak.reefBreak.rawValue
        case 3:
            return SurfBreak.pointBreak.rawValue
        default:
            return SurfBreak.outerBanks.rawValue
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let fields = getSectionFields(section: section)
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as! SpotCell
        let fields = getSectionFields(section: indexPath.section)
        let field = fields[indexPath.row]
        cell.setUpCell(field: field)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fields = getSectionFields(section: indexPath.section)
        let selectedSpot = fields[indexPath.row]
        
        moveToDetailView(selectedSpot: selectedSpot)
    }
    
    func moveToDetailView(selectedSpot: Fields?) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailSpotViewController") as? DetailSpotViewController {
            detailVC.spot = selectedSpot
            let backButton = UIBarButtonItem()
            navigationItem.backBarButtonItem = backButton
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: Switch display
extension ViewController {
    
    private func switchToList() {
        self.tableView.isHidden = false
        self.mapView?.isHidden = true
        currentDisplay = .list
    }
    
    private func switchToMap() {
        self.tableView.isHidden = true
        self.mapView?.isHidden = false
        currentDisplay = .map
    }
    
    @objc func switchDisplay() {
        switch currentDisplay {
        case .list:
            switchToMap()
        case .map:
            switchToList()
        }
    }
}

// MARK: - Map
extension ViewController {
    
    func selectedSpot(name: String) -> Fields? {
        guard let index = fields.firstIndex(where: { $0.destinationStateCountry == name }) else {
            return nil
        }
        return fields[index]
    }
    
    func setupMap() {
        let destinations = fields.compactMap { $0.destinationStateCountry }
        mapView = addSwiftUIView(swiftUIView: MapView(addresses: destinations, completion: { name in
            if let selectedSpot = self.selectedSpot(name: name) {
                self.moveToDetailView(selectedSpot: selectedSpot)
            }
        }))
        mapView?.frame = view.frame
        
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        
        let widthConstraint = NSLayoutConstraint(item: mapView!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: width)
        self.view.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: mapView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: height)
        self.view.addConstraint(heightConstraint)
        
        mapView?.isHidden = true
    }
}
