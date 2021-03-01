//
//  IntRepresentedString.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import Foundation


@propertyWrapper
struct IntRepresentedString: Decodable {
    let wrappedValue: String
    
    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let intValue = try container.decode(Int.self)
        self.wrappedValue = String(intValue)
    }
}




