//
//  FavoritePlaceViewModel.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 20/09/23.
//

import Foundation
import Combine

class FavoritePlaceViewModel: ObservableObject {
    
    private let favoritePlaceUseCase: FavoritePlaceUseCaseProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var places: [Place] = [Place]()
    @Published var errorMessage: String = ""
    @Published var isLoadingState: Bool = false
    
    init(favoritePlaceUseCase: FavoritePlaceUseCaseProtocol) {
        self.favoritePlaceUseCase = favoritePlaceUseCase
    }
    
    func getPlaces() {
        isLoadingState = true
        favoritePlaceUseCase.getFavoritePlaces()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.isLoadingState = false
                }
                
            }, receiveValue: { listOfPlace in
                self.places = listOfPlace
            })
            .store(in: &cancellables)
    }
}
