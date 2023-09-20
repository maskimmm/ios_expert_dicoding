//
//  FavoritePlaceInteractor.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 20/09/23.
//

import Foundation

protocol FavoritePlaceUseCaseProtocol {
    
    func getFavoritePlaces(completion: @escaping (Result<[Place], Error>) -> Void)
    
}

class FavoritePlaceInteractor: FavoritePlaceUseCaseProtocol {
    
    private let repository: PlaceRepositoryProtocol
    
    required init(repository: PlaceRepositoryProtocol) {
        self.repository = repository
    }
    
    func getFavoritePlaces(completion: @escaping (Result<[Place], Error>) -> Void) {
        repository.getFavoritePlaces { result in
            completion(result)
        }
    }
}
