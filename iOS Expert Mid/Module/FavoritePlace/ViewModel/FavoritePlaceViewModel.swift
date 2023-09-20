//
//  FavoritePlaceViewModel.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 20/09/23.
//

import Foundation

class FavoritePlaceViewModel: ObservableObject {
    
    private let favoritePlaceUseCase: FavoritePlaceUseCaseProtocol
    
    @Published var places: [Place] = [Place]()
    @Published var errorMessage: String = ""
    @Published var isLoadingState: Bool = false
    
    init(favoritePlaceUseCase: FavoritePlaceUseCaseProtocol) {
        self.favoritePlaceUseCase = favoritePlaceUseCase
    }
    
    func getPlaces() {
        isLoadingState = true
        favoritePlaceUseCase.getFavoritePlaces { result in
            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    self.isLoadingState = false
                    self.places = places
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoadingState = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
