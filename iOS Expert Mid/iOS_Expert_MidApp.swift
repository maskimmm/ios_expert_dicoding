//
//  iOS_Expert_MidApp.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 15/09/23.
//

import SwiftUI

@main
struct iOS_Expert_MidApp: App {
        
    let discoverPlaceVM = DiscoverPlaceViewModel(discoverPlaceUseCase: Injection.init().provideDiscoverPlace())
    let favoritePlaceVM = FavoritePlaceViewModel(favoritePlaceUseCase: Injection.init().provideFavoritePlace())
    
    @State private var navigationTitle: String = "Discover Place"
    @State private var tabNumber: Int = 0
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TabView(selection: $tabNumber) {
                    DiscoverPlaceView(discoverPlaceVM: discoverPlaceVM)
                        .tag(0)
                        .tabItem {
                            Label("Discover", systemImage: "location")
                        }
                    FavoritePlaceView(favoritePlaceVM: favoritePlaceVM)
                        .tag(1)
                        .tabItem {
                            Label("Favorite", systemImage: "bookmark")
                        }
                }
                .navigationTitle(navigationTitle)
                .onChange(of: tabNumber) { newValue in
                    if newValue == 0 {
                        navigationTitle = "Discover Place"
                    } else if newValue == 1 {
                        navigationTitle = "Favorite Place"
                    }
                }
            }
        }
    }
}
