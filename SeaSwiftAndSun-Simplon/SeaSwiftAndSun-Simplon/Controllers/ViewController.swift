//
//  ViewController.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Amandine Cousin on 05/12/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let apiManager = APIManager()
    let url = "https://api.airtable.com/v0/appLwnyGpn1sS3QSc/Surf%20Destinations"
    let token = "patKTpR8A45bdjdCl.e09bf84bc75e3c079b6ceda4de5abe8a2ee4bda1a82c268f98cb4667494b20dd"
    var records = [Record]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Liste des spots de surf"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            Task {
                let data: RecordData = try await self.apiManager.get(url: self.url, token: self.token)
                let records = data.records
                self.records = records
                self.tableView.reloadData()
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
}
