//
//  UnsplashModel.swift
//  Starter Project
//
//  Created by Esraa Khaled   on 28/03/2023.
//

import Foundation


struct ImageInfo: Codable {
    let urls: Urls
}

struct Urls: Codable {
    let full: String
    var fullUrl: URL {
        return URL(string: full)!
    }
}
