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
    
    func getPlaces() -> AnyPublisher<[PlaceEntity], Error>
    func addPlaces(from places: [PlaceEntity]) -> AnyPublisher<Bool, Error>
    
    func getFavPlaces() -> AnyPublisher<[FavPlaceEntity], Error>
    func addFavPlace(place: FavPlaceEntity) -> AnyPublisher<Bool, Error>
    func deleteFavPlace(_ id: Int) -> AnyPublisher<Bool, Error>
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
    
    func getPlaces() -> AnyPublisher<[PlaceEntity], Error> {
        return Future<[PlaceEntity], Error> { completion in
            if let realm = self.realm {
                let placeEntity: Results<PlaceEntity> = {
                    realm.objects(PlaceEntity.self)
                }()
                completion(.success(placeEntity.toArray(ofType: PlaceEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addPlaces(from places: [PlaceEntity]) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        for place in places {
                            realm.add(place, update: .all)
                        }
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getFavPlaces() -> AnyPublisher<[FavPlaceEntity], Error> {
        return Future<[FavPlaceEntity], Error> { completion in
            if let realm = self.realm {
                let favPlaceEntity: Results<FavPlaceEntity> = {
                    realm.objects(FavPlaceEntity.self)
                }()
                completion(.success(favPlaceEntity.toArray(ofType: FavPlaceEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addFavPlace(place: FavPlaceEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        realm.add(place, update: .all)
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteFavPlace(_ id: Int) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                if let placeToDelete = realm.objects(FavPlaceEntity.self).first(where: {$0.id == id}) {
                    do {
                        try realm.write {
                            realm.delete(placeToDelete)
                            completion(.success(true))
                        }
                    } catch {
                        completion(.failure(DatabaseError.requestFailed))
                    }
                } else {
                    completion(.failure(DatabaseError.invalidInstance))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
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
