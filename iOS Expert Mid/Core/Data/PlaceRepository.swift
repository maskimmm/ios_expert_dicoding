//
//  PlaceRepository.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 16/09/23.
//

import Foundation

protocol PlaceRepositoryProtocol {
    
    func getPlaces(completion: @escaping (Result<[Place], Error>) -> Void)
    
    func getFavoritePlaces(completion: @escaping (Result<[Place], Error>) -> Void)
    func addFavoritePlace(_ place: Place, completion: @escaping (Result<Bool, Error>) -> Void)
    func deleteFavoritePlace(_ place: Place, completion: @escaping (Result<Bool, Error>) -> Void)
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
    
    func getPlaces(completion: @escaping (Result<[Place], Error>) -> Void) {
        local.getPlaces { localResponse in
            switch localResponse {
                
            case .success(let placeEntity):
                let places = PlaceMapper.mapPlaceEntitiesToDomains(input: placeEntity)
                if places.isEmpty {
                  self.remote.getPlaces { remoteResponses in
                    switch remoteResponses {
                    case .success(let placeResponses):
                      let placeEntities = PlaceMapper.mapPlaceResponsesToEntities(input: placeResponses)
                      self.local.addPlaces(from: placeEntities) { addState in
                        switch addState {
                        case .success(let resultFromAdd):
                          if resultFromAdd {
                            self.local.getPlaces { localeResponses in
                              switch localeResponses {
                              case .success(let placeEntity):
                                let results = PlaceMapper.mapPlaceEntitiesToDomains(input: placeEntity)
                                completion(.success(results))
                              case .failure(let error):
                                completion(.failure(error))
                              }
                            }
                          }
                        case .failure(let error):
                          completion(.failure(error))
                        }
                      }
                    case .failure(let error):
                      completion(.failure(error))
                    }
                  }
                } else {
                  completion(.success(places))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getFavoritePlaces(completion: @escaping (Result<[Place], Error>) -> Void) {
        local.getFavPlaces { localResponse in
            switch localResponse {
            case .success(let placeEntity):
                let places = PlaceMapper.mapPlaceEntitiesToDomains(input: placeEntity)
                completion(.success(places))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addFavoritePlace(_ place: Place, completion: @escaping (Result<Bool, Error>) -> Void) {
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
        
        local.addFavPlace(place: favPlace) { response in
            switch response {
            case .success:
                completion(.success(true))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func deleteFavoritePlace(_ place: Place, completion: @escaping (Result<Bool, Error>) -> Void) {
        var favPlace = FavPlaceEntity()
        
        local.getFavPlaces { response in
            switch response {
            case .success(let results):
                if let result = results.first(where: {$0.id == place.id}) {
                    favPlace = result
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        
        local.deleteFavPlace(place: favPlace) { response in
            switch response {
            case .success:
                completion(.success(true))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
