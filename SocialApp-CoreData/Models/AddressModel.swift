//
//  Address.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import Foundation


//    "address": {
//        "street": "Kulas Light",
//        "suite": "Apt. 556",
//        "city": "Gwenborough",
//        "zipcode": "92998-3874",
//        "geo": {
//            "lat": "-37.3159",
//            "lng": "81.1496"
//        }
//    },
struct AddressModel: Decodable {
    
    let street: String
    
    let suite: String
    
    let city: String
    
    let zipcode: String
    
    //        "geo": {
    //            "lat": "-37.3159",
    //            "lng": "81.1496"
    //        }
    let geo: GeoModel
    
    struct GeoModel: Codable {
        
        let lat: String
        let lng: String
    }
}
