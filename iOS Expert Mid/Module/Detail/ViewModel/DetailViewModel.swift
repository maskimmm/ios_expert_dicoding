//
//  DetailViewModel.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 20/09/23.
//

import UIKit
import Combine

class DetailViewModel: ObservableObject {
    
    private let detailUseCase: DetailUseCaseProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var place: Place
    @Published var errorMessage: String = ""
    @Published var isLoadingState: Bool = false
    @Published var isFavorite: Bool = false
    
    init(detailUseCase: DetailUseCaseProtocol) {
        self.detailUseCase = detailUseCase
        place = detailUseCase.getDetailPlace()
        checkIsFavorite(place)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.isLoadingState = false
                }
                
            }, receiveValue: { _ in
            })
            .store(in: &cancellables)
    }
    
    func getUIImageFromString(_ imgUrl: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imgUrl) else { return completion(nil) }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            return
        }
    }
    
    func addFavPlace(_ place: Place) {
        detailUseCase.addFavoritePlace(place)
    }
    
    func deleteFavPlace(_ place: Place) {
        detailUseCase.deleteFavoritePlace(place)
    }
    
    func checkIsFavorite(_ place: Place) -> AnyPublisher<Bool, DatabaseError> {
        return detailUseCase.getFavoritePlaces()
            .tryMap { results in
                if let result = results.first(where: {$0.id == place.id}) {
                    self.isFavorite = true
                }
                return true
            }
            .mapError { _ in
                return DatabaseError.requestFailed
            }
            .eraseToAnyPublisher()
    }
}
