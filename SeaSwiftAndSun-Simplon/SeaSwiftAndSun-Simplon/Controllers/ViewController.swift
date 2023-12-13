//
//  ViewController.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Amandine Cousin on 05/12/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var collectionView: UICollectionView?
    
    let apiManager = APIManager()
    let url = "https://api.airtable.com/v0/appLwnyGpn1sS3QSc/Surf%20Destinations"
    let token = "patKTpR8A45bdjdCl.e09bf84bc75e3c079b6ceda4de5abe8a2ee4bda1a82c268f98cb4667494b20dd"
    var records = [Record]()
    
    var currentDisplay: ViewDisplay = .list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Liste des spots de surf"
        segmentedControl.addTarget(self, action: #selector(switchDisplay), for: .valueChanged)
        configureCollection()
        collectionView?.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            Task {
//                let data: RecordData = try await self.apiManager.get(url: self.url, token: self.token)
//                let records = data.records
//                self.records = records
//                self.tableView.reloadData()
//            }
//        }
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

        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailSpotViewController") as? DetailSpotViewController {
            detailVC.spot = selectedSpot
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: Switch display
extension ViewController {
    
    private func switchToList() {
        self.tableView.isHidden = false
        self.collectionView?.isHidden = true
        currentDisplay = .list
    }
    
    private func switchToCards() {
        self.tableView.isHidden = true
        self.collectionView?.isHidden = false
        currentDisplay = .cards
    }
    
    @objc func switchDisplay() {
        switch currentDisplay {
        case .list:
            switchToCards()
        case .cards:
            switchToList()
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func configureCollection() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, 
                                 height: UIScreen.main.bounds.height * 0.3)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "SpotCard")
        collectionView?.backgroundColor = UIColor.white
        view.addSubview(collectionView ?? UICollectionView())
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpotCard", for: indexPath)
        cell.backgroundColor = .black
        cell.layer.cornerRadius = 20
        return cell
    }
}
