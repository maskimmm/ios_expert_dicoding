//
//  PlacesResponse.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 16/09/23.
//

import Foundation

struct PlaceAPIResponse: Codable {
    
    let error: Bool
    let message: String
    let count: Int
    let places: [PlaceResponse]
    
}

struct PlaceResponse: Codable {
    
    let id: Int?
    let name: String?
    let description: String?
    let address: String?
    let longitude: Double?
    let latitude: Double?
    let like: Int?
    let image: String?
    
}
