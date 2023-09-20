//
//  RemoteDataSource.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 16/09/23.
//

import Foundation
import Alamofire

protocol RemoteDataSourceProtocol {
    
    func getPlaces(completion: @escaping (Result<[PlaceResponse], URLError>) -> Void)
    
}

final class RemoteDataSource: NSObject {
    
    private override init() { }
    
    static let sharedInstance: RemoteDataSource = RemoteDataSource()
}

extension RemoteDataSource: RemoteDataSourceProtocol {
    
    func getPlaces(completion: @escaping (Result<[PlaceResponse], URLError>) -> Void) {
        guard let url = URL(string: Endpoints.Gets.places.url) else { return }
        
        AF.request(url).validate().responseDecodable(of: PlaceAPIResponse.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value.places))
            case .failure:
                completion(.failure(.invalidResponse))
            }
        }
    }
    
}
