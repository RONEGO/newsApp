//
//  cellCustomScrollTableViewCell.swift
//  goraNews
//
//  Created by Yegor Geronin on 12.03.2022.
//

import UIKit

class cellCustomScroll: UITableViewCell {
    
    private var scrollViewNews = UIScrollView()
    
    public weak var mainView: mainViewController? = nil
    
    public func setArticles( with articles: [article], mainView: mainViewController) {
        if self.mainView == nil {
            self.mainView = mainView
        } else {
            subviews.forEach {
                $0.removeFromSuperview()
            }
        }
        // SET scroll
        let scrollViewNews = UIScrollView()
        addSubview(scrollViewNews)
        scrollViewNews.frame        = bounds
        scrollViewNews.contentSize  = CGSize(width: .widthArticle * CGFloat(articles.count)
                                             + .spacingStack,
                                             height: scrollViewNews.height)
        
        var count:CGFloat           = 0
        for article in articles {
            let cell = cellArticle(frame: CGRect(x: .widthArticle * count + .spacingStack,
                                                 y: 0,
                                                 width: .widthArticle,
                                                 height: .heightArticle))
            count += 1
            cell.setArticle(article: article, mainView: mainView)
            scrollViewNews.addSubview(cell)
        }
        
    }
}
