//
//  PlaceRepository.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 16/09/23.
//

import Foundation
import Combine

protocol PlaceRepositoryProtocol {
    
    func getPlaces() -> AnyPublisher<[Place], DatabaseError>
    
    func getFavoritePlaces() -> AnyPublisher<[Place], DatabaseError>
    func addFavoritePlace(_ place: Place) -> AnyPublisher<Bool, DatabaseError>
    func deleteFavoritePlace(_ place: Place) -> AnyPublisher<Bool, DatabaseError>
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
    
    func getPlaces() -> AnyPublisher<[Place], DatabaseError> {
        return self.local.getPlaces()
            .flatMap { result -> AnyPublisher<[Place], DatabaseError> in
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
    
    func getFavoritePlaces() -> AnyPublisher<[Place], DatabaseError> {
        return self.local.getFavPlaces()
            .flatMap { result -> AnyPublisher<[Place], DatabaseError> in
                return self.local.getFavPlaces()
                    .map { PlaceMapper.mapPlaceEntitiesToDomains(input: $0) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func addFavoritePlace(_ place: Place) -> AnyPublisher<Bool, DatabaseError> {
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
    
    func deleteFavoritePlace(_ place: Place) -> AnyPublisher<Bool, DatabaseError> {
        var places: [FavPlaceEntity] = [FavPlaceEntity]()
        
        self.local.getFavPlaces()
            .map { places = $0 }
            .eraseToAnyPublisher()
        
        if let placeToDelete = places.first(where: {$0.id == place.id}) {
            return self.local.deleteFavPlace(place: placeToDelete)
                .eraseToAnyPublisher()
        } else {
            return Just(false)
                .setFailureType(to: DatabaseError.self)
                .eraseToAnyPublisher()
        }
    }
}
