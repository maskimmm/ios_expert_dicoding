//
//  PlaceEntity.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 17/09/23.
//

import Foundation
import RealmSwift

class PlaceEntity: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var longitude: Double = 0
    @objc dynamic var latitude: Double = 0
    @objc dynamic var like: Int = 0
    @objc dynamic var image: String = ""

    override static func primaryKey() -> String? {
      return "id"
    }
}
