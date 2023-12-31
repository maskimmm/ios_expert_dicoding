//
//  RemoteDataSource.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 16/09/23.
//

import Foundation
import Alamofire
import Combine

protocol RemoteDataSourceProtocol {
    
    func getPlaces() -> AnyPublisher<[PlaceResponse], Error>
    
}

final class RemoteDataSource: NSObject {
    
    private override init() { }
    
    static let sharedInstance: RemoteDataSource = RemoteDataSource()
}

extension RemoteDataSource: RemoteDataSourceProtocol {
    
    func getPlaces() -> AnyPublisher<[PlaceResponse], Error> {
        return Future<[PlaceResponse], Error> { completion in
            if let url = URL(string: Endpoints.Gets.places.url) {
                AF.request(url).validate().responseDecodable(of: PlaceAPIResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        completion(.success(value.places))
                    case .failure:
                        completion(.failure(DatabaseError.invalidInstance))
                    }
                    
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
}
