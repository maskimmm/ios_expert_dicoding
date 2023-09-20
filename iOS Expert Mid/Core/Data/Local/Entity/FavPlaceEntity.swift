//
//  FavPlaceEntity.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 20/09/23.
//

import Foundation
import RealmSwift

class FavPlaceEntity: PlaceEntity {
    
    @objc dynamic var dateAdded: Date = Date.now
}
