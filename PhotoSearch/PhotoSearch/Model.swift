//
//  Parcing JSON?.swift
//  PhotoSearch
//
//  Created by Anton on 31.01.2022.
//

import Foundation

struct APIResponse:Codable {
    let total:Int
    let total_pages:Int
    let results:[Result]
}
struct Result:Codable {
    let id:String
    let urls:URLS
}

struct URLS:Codable {
    let regular: String
}

