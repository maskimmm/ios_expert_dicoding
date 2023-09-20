//
//  DiscoverPlaceViewModel.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 16/09/23.
//

import Foundation

class DiscoverPlaceViewModel: ObservableObject {
    
    private let discoverPlaceUseCase: DiscoverPlaceUseCaseProtocol
    
    @Published var places: [Place] = [Place]()
    @Published var errorMessage: String = ""
    @Published var isLoadingState: Bool = false
    
    init(discoverPlaceUseCase: DiscoverPlaceUseCaseProtocol) {
        self.discoverPlaceUseCase = discoverPlaceUseCase
    }
    
    func getPlaces() {
        isLoadingState = true
        discoverPlaceUseCase.getPlaces { result in
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
