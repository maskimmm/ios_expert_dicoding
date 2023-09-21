//
//  DetailInteractor.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 20/09/23.
//

import Foundation
import Combine

protocol DetailUseCaseProtocol {
    
    func getDetailPlace() -> Place
    func getFavoritePlaces() -> AnyPublisher<[Place], DatabaseError>
//    func checkIsFavorite(_ place: Place) -> Bool
    func addFavoritePlace(_ place: Place)
    func deleteFavoritePlace(_ place: Place)
}

class DetailInteractor: DetailUseCaseProtocol {
    
    private let repository: PlaceRepositoryProtocol
    private let place: Place
    
    required init(repository: PlaceRepositoryProtocol, place: Place) {
        self.repository = repository
        self.place = place
    }
    
    func getDetailPlace() -> Place {
        return place
    }
    
    func getFavoritePlaces() -> AnyPublisher<[Place], DatabaseError> {
        return self.repository.getFavoritePlaces()
            .eraseToAnyPublisher()
    }
    
//    func checkIsFavorite(_ place: Place) -> Bool {
////        var isFavorite: Bool = false
//        self.repository.getFavoritePlaces()
//            .map { result in
//                var isFavorite: Bool = false
//                if let place = result.first(where: {$0.id == place.id}) {
//                    isFavorite = true
//                } else {
//                    isFavorite = false
//                }
//                return isFavorite
//            }
//            .eraseToAnyPublisher()
////        return isFavorite
//
////        self.repository.getFavoritePlaces()
////            .eraseToAnyPublisher()
//
////        return false
////            .map { places in
////                if let result = places.first(where: { $0.id == place.id}) {
////                    return true
////                } else {
////                    return false
////                }
////                return false
////            }
////            .eraseToAnyPublisher()
//    }
    
    func addFavoritePlace(_ place: Place) {
        self.repository.addFavoritePlace(place)
            .eraseToAnyPublisher()
    }
    
    func deleteFavoritePlace(_ place: Place) {
        self.repository.deleteFavoritePlace(place)
            .eraseToAnyPublisher()
    }
}
