//
//  Model.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Tatiana Simmer on 11/12/2023.
//

import Foundation

// MARK: - RecordData
struct RecordData: Codable {
    let records: [Record]
}

// MARK: - Record
struct Record: Codable {
    let id, createdTime: String
    let fields: Fields
}

// MARK: - Fields
struct Fields: Codable {
    let peakSurfSeasonBegins, destinationStateCountry, peakSurfSeasonEnds: String
    let difficultyLevel: Int
    let destination: String
    let surfBreak: [SurfBreak]
    let magicSeaweedLink: String
    let photos: [Photo]
    let address: String
    let influencers: [Influencer]?
    let travellers: [String]?

    enum CodingKeys: String, CodingKey {
        case peakSurfSeasonBegins = "Peak Surf Season Begins"
        case destinationStateCountry = "Destination State/Country"
        case peakSurfSeasonEnds = "Peak Surf Season Ends"
        case difficultyLevel = "Difficulty Level"
        case destination = "Destination"
        case surfBreak = "Surf Break"
        case magicSeaweedLink = "Magic Seaweed Link"
        case photos = "Photos"
        case address = "Address"
        case influencers = "Influencers"
        case travellers = "Travellers"
    }
}

enum Influencer: String, Codable {
    case rec6XXh0NA3YateHo = "rec6XXh0NA3yateHo"
    case recRENCkIVsaoGUPD = "recRENCkIVsaoGUPd"
    case recf2Hoa8CLQojEYy = "recf2Hoa8CLQojEYy"
}

// MARK: - Photo
struct Photo: Codable {
    let id: String
    let width, height: Int
    let url: String
    let filename: String
    let size: Int
    let type: TypeEnum
    let thumbnails: Thumbnails
}

// MARK: - Thumbnails
struct Thumbnails: Codable {
    let small, large, full: Full
}

// MARK: - Full
struct Full: Codable {
    let url: String
    let width, height: Int
}

enum TypeEnum: String, Codable {
    case imageJPEG = "image/jpeg"
}

enum SurfBreak: String, CaseIterable, Codable {
    case beachBreak = "Beach Break"
    case reefBreak = "Reef Break"
    case pointBreak = "Point Break"
    case outerBanks = "Outer Banks"
}
