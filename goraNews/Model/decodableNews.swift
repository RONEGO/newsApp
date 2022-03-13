//
//  decodableNews.swift
//  goraNews
//
//  Created by Yegor Geronin on 12.03.2022.
//

import Foundation

struct requestNews: Decodable {
    let totalResults:   Int
    let articles:       [articleNews]
}

struct articleNews: Decodable {
    let title:          String
    let url:            String
    let urlToImage:     String?
    let publishedAt:    String
}
