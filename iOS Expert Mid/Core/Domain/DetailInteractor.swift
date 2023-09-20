//
//  DetailInteractor.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 20/09/23.
//

import Foundation

protocol DetailUseCaseProtocol {
    
    func getDetailPlace() -> Place
    func checkIsFavorite(_ place: Place) -> Bool
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
    
    func checkIsFavorite(_ place: Place) -> Bool {
        var isFavorite: Bool = false
        repository.getFavoritePlaces { response in
            switch response {
            case .success(let success):
                if let result = success.first(where: {$0.id == place.id}) {
                    isFavorite = true
                } else {
                    isFavorite = false
                }
            case .failure:
                isFavorite = false
            }
        }
        return isFavorite
    }
    
    func addFavoritePlace(_ place: Place) {
        repository.addFavoritePlace(place) { response in
            switch response {
            case .success:
                print("\(place.name) added to favorite.")
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func deleteFavoritePlace(_ place: Place) {
        repository.deleteFavoritePlace(place) { response in
            switch response {
            case .success:
                print("\(place.name) deleted to favorite.")
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
