//
//  Model.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Tatiana Simmer on 11/12/2023.
//

import Foundation

// MARK: - RecordData
public struct RecordData: Codable {
    
    public init(records: [Record]) {
        self.records = records
    }
    
    let records: [Record]
}

// MARK: - Record
public struct Record: Codable {
    
    public init(id: String? = nil,
                createdTime: String? = nil,
                fields: Fields) {
        self.id = id
        self.createdTime = createdTime
        self.fields = fields
    }
    
    let id, createdTime: String?
    let fields: Fields
}

// MARK: - Fields
public struct Fields: Codable {
    
    public init(peakSurfSeasonBegins: String,
                destinationStateCountry: String?,
                peakSurfSeasonEnds: String,
                difficultyLevel: Int,
                destination: String,
                surfBreak: [SurfBreak],
                magicSeaweedLink: String?,
                photos: [Photo],
                address: String?,
                influencers: [String]?)
    {
        self.peakSurfSeasonBegins = peakSurfSeasonBegins
        self.destinationStateCountry = destinationStateCountry
        self.peakSurfSeasonEnds = peakSurfSeasonEnds
        self.difficultyLevel = difficultyLevel
        self.destination = destination
        self.surfBreak = surfBreak
        self.magicSeaweedLink = magicSeaweedLink
        self.photos = photos
        self.address = address
        self.influencers = influencers
    }
    
    let peakSurfSeasonBegins, peakSurfSeasonEnds: String
    let destinationStateCountry: String?
    let difficultyLevel: Int
    let destination: String
    let surfBreak: [SurfBreak]
    let magicSeaweedLink: String?
    let photos: [Photo]?
    let address: String?
    let influencers: [String]?
    
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
    }
}

// MARK: - Photo
public struct Photo: Codable {
    let url: String
}

// MARK: - Thumbnails
public struct Thumbnails: Codable {
    
    public init(small: Full,
                large: Full,
                full: Full) {
        self.small = small
        self.large = large
        self.full = full
    }
    
    let small, large, full: Full
}

// MARK: - Full
public struct Full: Codable {
    
    public init(url: String,
                width: Int,
                height: Int) {
        self.url = url
        self.width = width
        self.height = height
    }
    
    let url: String
    let width, height: Int
}

public enum TypeEnum: String, Codable {
    case imageJPEG = "image/jpeg"
}

public enum SurfBreak: String, CaseIterable, Codable {
    case beachBreak = "Beach Break"
    case reefBreak = "Reef Break"
    case pointBreak = "Point Break"
    case outerBanks = "Outer Banks"
}
