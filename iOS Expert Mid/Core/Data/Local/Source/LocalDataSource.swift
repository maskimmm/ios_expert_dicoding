//
//  LocalDataSource.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 17/09/23.
//

import Foundation
import RealmSwift
import Combine

protocol LocalDataSourceProtocol {
    
    func getPlaces() -> AnyPublisher<[PlaceEntity], DatabaseError>
    func addPlaces(from places: [PlaceEntity]) -> AnyPublisher<Bool, DatabaseError>
    
    func getFavPlaces() -> AnyPublisher<[FavPlaceEntity], DatabaseError>
    func addFavPlace(place: FavPlaceEntity) -> AnyPublisher<Bool, DatabaseError>
    func deleteFavPlace(place: FavPlaceEntity) -> AnyPublisher<Bool, DatabaseError>
}

final class LocalDataSource: NSObject {
    
    private let realm: Realm?

    private init(realm: Realm?) {
        self.realm = realm
    }

    static let sharedInstance: (Realm?) -> LocalDataSource = { realmDatabase in
      return LocalDataSource(realm: realmDatabase)
    }

}

extension LocalDataSource: LocalDataSourceProtocol {
    
    func getPlaces() -> AnyPublisher<[PlaceEntity], DatabaseError> {
        return Future<[PlaceEntity], DatabaseError> { completion in
            if let realm = self.realm {
                let placeEntity: Results<PlaceEntity> = {
                    realm.objects(PlaceEntity.self)
                }()
                completion(.success(placeEntity.toArray(ofType: PlaceEntity.self)))
            } else {
                completion(.failure(.invalidInstance))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addPlaces(from places: [PlaceEntity]) -> AnyPublisher<Bool, DatabaseError>{
        return Future<Bool, DatabaseError> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        for place in places {
                            realm.add(place, update: .all)
                        }
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(.requestFailed))
                }
            } else {
                completion(.failure(.invalidInstance))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getFavPlaces() -> AnyPublisher<[FavPlaceEntity], DatabaseError> {
        return Future<[FavPlaceEntity], DatabaseError> { completion in
            if let realm = self.realm {
                let favPlaceEntity: Results<FavPlaceEntity> = {
                    realm.objects(FavPlaceEntity.self)
                }()
                completion(.success(favPlaceEntity.toArray(ofType: FavPlaceEntity.self)))
            } else {
                completion(.failure(.invalidInstance))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addFavPlace(place: FavPlaceEntity) -> AnyPublisher<Bool, DatabaseError> {
        return Future<Bool, DatabaseError> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        realm.add(place, update: .all)
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(.requestFailed))
                }
            } else {
                completion(.failure(.invalidInstance))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteFavPlace(place: FavPlaceEntity) -> AnyPublisher<Bool, DatabaseError> {
        return Future<Bool, DatabaseError> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        realm.delete(place)
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(.requestFailed))
                }
            } else {
                completion(.failure(.invalidInstance))
            }
        }
        .eraseToAnyPublisher()
    }
}

extension Results {

  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for index in 0 ..< count {
      if let result = self[index] as? T {
        array.append(result)
      }
    }
    return array
  }

}
