//
//  Mapper.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 16/09/23.
//

import Foundation

final class PlaceMapper {
    
    static func mapPlaceResponsesToEntities(
        input placeResponses: [PlaceResponse]
    ) -> [PlaceEntity] {
        return placeResponses.map { result in
            let newPlace = PlaceEntity()
            newPlace.id = result.id ?? 0
            newPlace.name = result.name ?? "Unknown"
            newPlace.desc = result.description ?? "Unknown"
            newPlace.address = result.address ?? "Unknown"
            newPlace.longitude = result.longitude ?? 0
            newPlace.latitude = result.latitude ?? 0
            newPlace.like = result.like ?? 0
            newPlace.image = result.image ?? ""
            return newPlace
        }
    }
    
    static func mapPlaceEntitiesToDomains(
        input placeEntities: [PlaceEntity]
    ) -> [Place] {
        return placeEntities.map { result in
            return Place(
                id: result.id,
                         name: result.name,
                         description: result.desc,
                address: result.address,
                longitude: result.longitude,
                latitude: result.latitude,
                like: result.like,
                image: result.image)
        }
    }
    
    static func mapPlaceResponsesToDomains(input placeResponses: [PlaceResponse]) -> [Place] {
        return placeResponses.map { result in
            return Place(
                id: result.id ?? 0,
                name: result.name ?? "Unknown",
                description: result.description ?? "",
                address: result.address ?? "",
                longitude: result.longitude ?? 0,
                latitude: result.latitude ?? 0,
                like: result.like ?? 0,
                image: result.image ?? ""
            )
        }
    }
}

final class FavPlaceMapper {
    
    static func mapFavPlaceEntitiesToDomains(
        input placeEntities: [FavPlaceEntity]
    ) -> [Place] {
        return placeEntities.map { result in
            return Place(
                id: result.id,
                         name: result.name,
                         description: result.desc,
                address: result.address,
                longitude: result.longitude,
                latitude: result.latitude,
                like: result.like,
                image: result.image)
        }
    }
    
}
