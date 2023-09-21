//
//  DiscoverPlaceInteractor.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 16/09/23.
//

import Foundation
import Combine

protocol DiscoverPlaceUseCaseProtocol {
    
    func getPlaces() -> AnyPublisher<[Place], DatabaseError>
    
}

class DiscoverPlaceInteractor: DiscoverPlaceUseCaseProtocol {
    
    private let repository: PlaceRepositoryProtocol
    
    required init(repository: PlaceRepositoryProtocol) {
        self.repository = repository
    }
    
    func getPlaces() -> AnyPublisher<[Place], DatabaseError> {
        return self.repository.getPlaces()
    }
}
