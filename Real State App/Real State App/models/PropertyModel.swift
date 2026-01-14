//
//  PropertyModel.swift
//  Real State App
//
//  Created by Arpit Verma on 1/4/26.
//

import Foundation

struct FloorModel: Identifiable {
    var id : UUID = UUID()
    var image: String
    var video: String
    var name : String
}
struct PropertyModel: Identifiable {
    var id: UUID = UUID()
    let bedCount: Int
    let bathCount: Int
    let propertyName: String
    let monthlyRent: Int
    let propertyArea: Int
    let fhaEnable: Bool
    let singleSotry: Bool
    let description: String
    let location: String
    let image : String
    let video: String
    let floors: [FloorModel]
}



var sampleProperties : [ PropertyModel] = [
    PropertyModel(bedCount: 3, bathCount: 2, propertyName: "William Creek Manor", monthlyRent: 3690, propertyArea: 1940, fhaEnable: false, singleSotry: true, description: "abc ", location: "adasa", image: "real state 1", video: "real state 1.mp4", floors: [ FloorModel(image: "plan1",video : "interior.mp4", name :"Floor 1" ), FloorModel(image: "plan2", video: "interior.mp4", name: "Floor 2"), FloorModel(image: "plan3", video: "interior.mp4", name: "Floor 3")]),
    PropertyModel(bedCount: 5, bathCount: 4, propertyName: "Live Oak Meadown", monthlyRent: 4500, propertyArea: 2155, fhaEnable: false, singleSotry: true, description: "Escape to luxury in this modern architectural gem perched above the coastline. Midnight Ocean Villa offers panoramic ocean views", location: "Riverton, NJ", image: "real state 3", video: "real state 1.mp4", floors: [ FloorModel(image: "plan1",video : "interior.mp4", name :"Floor 1" ), FloorModel(image: "plan2", video: "interior.mp4", name: "Floor 2"), FloorModel(image: "plan3", video: "interior.mp4", name: "Floor 3")])
    ,
    PropertyModel(bedCount: 5, bathCount: 4, propertyName: "Live Oak Meadown", monthlyRent: 4500, propertyArea: 2155, fhaEnable: false, singleSotry: true, description: "abc ", location: "adasa", image: "real state 2", video: "real state 1.mp4", floors: [ FloorModel(image: "plan1",video : "plan1", name :"Floor 1" ), FloorModel(image: "plan2", video: "plan2", name: "Floor 2"), FloorModel(image: "plan3", video: "plan3", name: "Floor 3")]),
    PropertyModel(bedCount: 5, bathCount: 4, propertyName: "Live Oak Meadown", monthlyRent: 4500, propertyArea: 2155, fhaEnable: false, singleSotry: true, description: "abc ", location: "adasa", image: "real state 3", video: "real state 1.mp4", floors: [ FloorModel(image: "plan1",video : "plan1", name :"Floor 1" ), FloorModel(image: "plan2", video: "plan2", name: "Floor 2"), FloorModel(image: "plan3", video: "plan3", name: "Floor 3")])
    
]
