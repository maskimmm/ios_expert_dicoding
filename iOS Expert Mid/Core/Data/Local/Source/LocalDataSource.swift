//
//  LocalDataSource.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 17/09/23.
//

import Foundation
import RealmSwift

protocol LocalDataSourceProtocol {
    
    func getPlaces(completion: @escaping (Result<[PlaceEntity], DatabaseError>) -> Void)
    func addPlaces(from places: [PlaceEntity], completion: @escaping (Result<Bool, DatabaseError>) -> Void)
    
    func getFavPlaces(completion: @escaping (Result<[FavPlaceEntity], DatabaseError>) -> Void)
    func addFavPlace(place: FavPlaceEntity, completion: @escaping (Result<Bool, DatabaseError>) -> Void)
    func deleteFavPlace(place: FavPlaceEntity, completion: @escaping (Result<Bool, DatabaseError>) -> Void)
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
    
    func getPlaces(completion: @escaping (Result<[PlaceEntity], DatabaseError>) -> Void) {
        if let realm = realm {
            let placeEntity: Results<PlaceEntity> = {
                realm.objects(PlaceEntity.self)
            }()
            completion(.success(placeEntity.toArray(ofType: PlaceEntity.self)))
        } else {
            completion(.failure(.invalidInstance))
        }
    }
    
    func addPlaces(from places: [PlaceEntity], completion: @escaping (Result<Bool, DatabaseError>) -> Void) {
        if let realm = realm {
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
    
    func getFavPlaces(completion: @escaping (Result<[FavPlaceEntity], DatabaseError>) -> Void) {
        if let realm = realm {
            let favPlaceEntity: Results<FavPlaceEntity> = {
                realm.objects(FavPlaceEntity.self)
            }()
            completion(.success(favPlaceEntity.toArray(ofType: FavPlaceEntity.self)))
        } else {
            completion(.failure(.invalidInstance))
        }
    }
    
    func addFavPlace(place: FavPlaceEntity, completion: @escaping (Result<Bool, DatabaseError>) -> Void) {
        if let realm = realm {
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
    
    func deleteFavPlace(place: FavPlaceEntity, completion: @escaping (Result<Bool, DatabaseError>) -> Void) {
        if let realm = realm {
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
