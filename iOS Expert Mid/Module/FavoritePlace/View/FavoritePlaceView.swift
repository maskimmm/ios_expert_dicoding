//
//  FavoritePlaceView.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 20/09/23.
//

import SwiftUI

struct FavoritePlaceView: View {
    
    @ObservedObject var favoritePlaceVM: FavoritePlaceViewModel
    
    var body: some View {
        
        ZStack {
            if favoritePlaceVM.isLoadingState {
                VStack {
                    Text("Please Wait...")
                    ProgressView()
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(
                        self.favoritePlaceVM.places, id: \.id
                    ) { place in
                        NavigationLink {
                            DetailView(
                                detailVM: DetailViewModel(
                                    detailUseCase: Injection.init().provideDetail(place)
                                )
                            )
                            .navigationTitle("\(place.name) Detail")
                        } label: {
                            DiscoverPlaceRow(place: place)
                        }
                    }
                }
            }
        }
        .onAppear {
            self.favoritePlaceVM.getPlaces()
        }
    }
}

struct FavoritePlaceView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritePlaceView(
            favoritePlaceVM: FavoritePlaceViewModel(
                favoritePlaceUseCase: Injection.init().provideFavoritePlace()
            )
        )
    }
}
