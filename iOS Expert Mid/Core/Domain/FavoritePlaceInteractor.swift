//
//  FavoritePlaceInteractor.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 20/09/23.
//

import Foundation
import Combine

protocol FavoritePlaceUseCaseProtocol {
    
    func getFavoritePlaces() -> AnyPublisher<[Place], Error>
    
}

class FavoritePlaceInteractor: FavoritePlaceUseCaseProtocol {
    
    private let repository: PlaceRepositoryProtocol
    
    required init(repository: PlaceRepositoryProtocol) {
        self.repository = repository
    }
    
    func getFavoritePlaces() -> AnyPublisher<[Place], Error> {
        return self.repository.getFavoritePlaces()
    }
}
