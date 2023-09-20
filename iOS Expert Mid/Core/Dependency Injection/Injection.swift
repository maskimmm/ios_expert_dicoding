//
//  Injection.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 16/09/23.
//

import Foundation
import RealmSwift

final class Injection: NSObject {
    
    private func provideRepository() -> PlaceRepositoryProtocol {
        let realm = try? Realm()

        let local: LocalDataSource = LocalDataSource.sharedInstance(realm)
        let remote: RemoteDataSource = RemoteDataSource.sharedInstance
        
        return PlaceRepository.sharedInstance(local, remote)
    }
    
    func provideDiscoverPlace() -> DiscoverPlaceUseCaseProtocol {
        let repository = provideRepository()
        return DiscoverPlaceInteractor(repository: repository)
    }
    
    func provideFavoritePlace() -> FavoritePlaceUseCaseProtocol {
        let repository = provideRepository()
        return FavoritePlaceInteractor(repository: repository)
    }
    func provideDetail(_ place: Place) -> DetailUseCaseProtocol {
        let repository = provideRepository()
        return DetailInteractor(repository: repository, place: place)
    }
}
