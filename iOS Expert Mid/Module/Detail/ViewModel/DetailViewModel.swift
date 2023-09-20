//
//  DetailViewModel.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 20/09/23.
//

import UIKit

class DetailViewModel: ObservableObject {
    
    private let detailUseCase: DetailUseCaseProtocol
    
    @Published var place: Place
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
    }
    
    func deleteFavPlace(_ place: Place) {
        detailUseCase.deleteFavoritePlace(place)
    }
    
    func checkIsFavorite(_ place: Place) {
        isFavorite = detailUseCase.checkIsFavorite(place)
    }
}
