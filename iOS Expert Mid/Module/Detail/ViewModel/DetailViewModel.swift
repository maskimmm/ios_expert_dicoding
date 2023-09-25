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
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.errorMessage = ""
                }
            }, receiveValue: { value in
                if value {
                    print("\(place.name) added to favorite")
                    self.isFavorite = true
                } else {
                    print("error add \(place.name) to favorite")
                }
            })
            .store(in: &cancellables)
    }
    
    func deleteFavPlace(_ place: Place) {
        detailUseCase.deleteFavoritePlace(place.id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.errorMessage = ""
                }
            }, receiveValue: { value in
                if value {
                    print("\(place.name) deleted from favorite")
                    self.isFavorite = false
                } else {
                    print("error delete \(place.name) from favorite")
                }
            })
            .store(in: &cancellables)
    }
    
    func checkIsFavorite(_ place: Place) {
        detailUseCase.getFavoritePlaces()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.isLoadingState = false
                }
                
            }, receiveValue: { value in
                if value.first(where: {$0.id == self.place.id}) != nil {
                    self.isFavorite = true
                } else {
                    self.isFavorite = false
                }
            })
            .store(in: &cancellables)
    }
}
