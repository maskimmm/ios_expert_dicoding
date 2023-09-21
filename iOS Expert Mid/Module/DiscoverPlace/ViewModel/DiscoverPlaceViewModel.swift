//
//  DiscoverPlaceViewModel.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 16/09/23.
//

import Foundation
import Combine

class DiscoverPlaceViewModel: ObservableObject {
    
    private let discoverPlaceUseCase: DiscoverPlaceUseCaseProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var places: [Place] = [Place]()
    @Published var errorMessage: String = ""
    @Published var isLoadingState: Bool = false
    
    init(discoverPlaceUseCase: DiscoverPlaceUseCaseProtocol) {
        self.discoverPlaceUseCase = discoverPlaceUseCase
    }
    
    func getPlaces() {
        isLoadingState = true
        discoverPlaceUseCase.getPlaces()
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
