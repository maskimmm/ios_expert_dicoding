//
//  DiscoverPlaceInteractor.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 16/09/23.
//

import Foundation

protocol DiscoverPlaceUseCaseProtocol {
    
    func getPlaces(completion: @escaping (Result<[Place], Error>) -> Void)
    
}

class DiscoverPlaceInteractor: DiscoverPlaceUseCaseProtocol {
    
    private let repository: PlaceRepositoryProtocol
    
    required init(repository: PlaceRepositoryProtocol) {
        self.repository = repository
    }
    
    func getPlaces(completion: @escaping (Result<[Place], Error>) -> Void) {
        repository.getPlaces { result in
            completion(result)
        }
    }
}
