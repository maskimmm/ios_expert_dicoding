//
//  PlaceAPICall.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 16/09/23.
//

import Foundation

struct PlaceAPI {
    
    static let baseUrl = "https://tourism-api.dicoding.dev/"
    
}

protocol Endpoint {
    
    var url: String { get }
    
}

enum Endpoints {
    
    enum Gets: Endpoint {
        case places
        
        public var url: String {
            switch self {
            case .places: return "\(PlaceAPI.baseUrl)list"
            }
        }
    }
}
