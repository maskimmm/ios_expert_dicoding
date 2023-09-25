//
//  PlaceRepository.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 16/09/23.
//

import Foundation
import Combine

protocol PlaceRepositoryProtocol {
    
    func getPlaces() -> AnyPublisher<[Place], Error>
    
    func getFavoritePlaces() -> AnyPublisher<[Place], Error>
    func addFavoritePlace(_ place: Place) -> AnyPublisher<Bool, Error>
    func deleteFavoritePlace(_ id: Int) -> AnyPublisher<Bool, Error>
}

class PlaceRepository: NSObject {
    
    typealias PlaceInstance = (LocalDataSource, RemoteDataSource) -> PlaceRepository
    
    fileprivate let local: LocalDataSource
    fileprivate let remote: RemoteDataSource
    
    private init(local: LocalDataSource, remote: RemoteDataSource) {
        self.local = local
        self.remote = remote
    }
    
    static let sharedInstance: PlaceInstance = { localRepository, remoteRepository in
        return PlaceRepository(local: localRepository, remote: remoteRepository)
    }
    
}

extension PlaceRepository: PlaceRepositoryProtocol {
    
    func getPlaces() -> AnyPublisher<[Place], Error> {
        return self.local.getPlaces()
            .flatMap { result -> AnyPublisher<[Place], Error> in
                if result.isEmpty {
                    return self.remote.getPlaces()
                        .map { PlaceMapper.mapPlaceResponsesToEntities(input: $0) }
                        .flatMap { self.local.addPlaces(from: $0) }
                        .filter { $0 }
                        .flatMap { _ in self.local.getPlaces()
                                .map { PlaceMapper.mapPlaceEntitiesToDomains(input: $0)}
                        }
                        .eraseToAnyPublisher()
                } else {
                    return self.local.getPlaces()
                        .map { PlaceMapper.mapPlaceEntitiesToDomains(input: $0) }
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getFavoritePlaces() -> AnyPublisher<[Place], Error> {
        return self.local.getFavPlaces()
            .map { FavPlaceMapper.mapFavPlaceEntitiesToDomains(input: $0) }
            .eraseToAnyPublisher()
    }
    
    func addFavoritePlace(_ place: Place) -> AnyPublisher<Bool, Error> {
        let favPlace = FavPlaceEntity()
        
        favPlace.id = place.id
        favPlace.name = place.name
        favPlace.desc = place.description
        favPlace.address = place.address
        favPlace.latitude = place.latitude
        favPlace.longitude = place.longitude
        favPlace.like = place.like
        favPlace.image = place.image
        favPlace.dateAdded = Date.now
        
        return self.local.addFavPlace(place: favPlace)
            .eraseToAnyPublisher()
    }
    
    func deleteFavoritePlace(_ id: Int) -> AnyPublisher<Bool, Error> {
        return self.local.deleteFavPlace(id)
            .eraseToAnyPublisher()
    }
}
