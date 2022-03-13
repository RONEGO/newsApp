//
//  categoryNews.swift
//  goraNews
//
//  Created by Yegor Geronin on 12.03.2022.
//

import Foundation

enum categories: String, CaseIterable {
    case business       = "Business"
    case health         = "Health"
    case technology     = "Technology"
    case entertainment  = "Entertainment"
    case science        = "Science"
    case sports         = "Sports"
}

struct categoryStruct {
    let title:  String
    var news:   [article]
}

struct article {
    let title:      String
    let url:        String
    let urlToImage: String?
    let date:       Date
}
