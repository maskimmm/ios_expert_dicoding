//
//  DiscoverPlaceView.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 16/09/23.
//

import SwiftUI

struct DiscoverPlaceView: View {
    
    @ObservedObject var discoverPlaceVM: DiscoverPlaceViewModel
    
    var body: some View {
        ZStack {
            if discoverPlaceVM.isLoadingState {
                VStack {
                    Text("Please Wait...")
                    ProgressView()
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(
                        self.discoverPlaceVM.places, id: \.id
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
//        .navigationTitle("Discover Place")
        .onAppear {
            self.discoverPlaceVM.getPlaces()
        }
    }
}

struct DiscoverPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DiscoverPlaceView(
                discoverPlaceVM: DiscoverPlaceViewModel(
                    discoverPlaceUseCase: Injection.init().provideDiscoverPlace()
                )
            )
        }
    }
}
