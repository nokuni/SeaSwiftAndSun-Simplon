//
//  MapView.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Yann Christophe Maertens on 14/12/2023.
//

import SwiftUI
import MapKit

struct City: Identifiable {
    var id = UUID()
    let name: String
    let originalName: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @State var position: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)))
    var addresses: [String]
    var completion: ((String) -> Void)?
    @State var cities: [City] = []
    var body: some View {
        Map(position: $position) {
            ForEach(cities) { city in
                Annotation(city.name, coordinate: city.coordinate) {
                    selectSpotButton(city: city)
                }
            }
        }
        .onAppear {
            setupCities()
        }
    }
    
    @ViewBuilder
    func selectSpotButton(city: City) -> some View {
        Button {
            completion?(city.originalName)
        } label: {
            Image(systemName: "figure.surfing")
                .foregroundStyle(.black)
                .font(.title)
        }
    }
    
    func setupCities() {
        Task {
            for address in addresses {
                if let placemark = try await getPlacemark(address: address) {
                    if let name = placemark.name,
                        let coordinate = placemark.location?.coordinate {
                        let city = City(name: name,
                                        originalName: address, coordinate: coordinate)
                        cities.append(city)
                    }
                }
            }
        }
    }
    
    func getPlacemark(address: String) async throws -> CLPlacemark? {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.geocodeAddressString(address)
        return placemarks.first
    }
}

#Preview {
    MapView(addresses: ["Paris", "Brussels"])
}
