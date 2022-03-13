//
//  cellArticle.swift
//  goraNews
//
//  Created by Yegor Geronin on 12.03.2022.
//

import UIKit

class cellArticle: UIView {
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled  = true
        imageView.backgroundColor           = .systemBackground
        imageView.contentMode               = .scaleAspectFill
        imageView.clipsToBounds             = true
        imageView.layer.cornerRadius        = 20
        return imageView
    }()
    
    private let lable: UILabel = {
        let lable = UILabel()
        lable.layer.cornerRadius    = 20
        lable.numberOfLines         = 10
        lable.textAlignment         = .right
        lable.textColor             = .white
        return lable
    }()
    
    private let viewShadow: UIView = {
        let viewShadow = UIView()
        viewShadow.backgroundColor      = .systemBackground
        viewShadow.layer.shadowColor     = UIColor.black.cgColor
        viewShadow.layer.shadowOffset    = .zero
        viewShadow.layer.shadowOpacity   = 0.6
        viewShadow.layer.shadowRadius    = 6
        return viewShadow
    }()
    
    private var news: article!
    private weak var mainView: mainViewController? = nil
    
    @objc
    private func articleTapped() {
        guard let mv = mainView else {
            return
        }
        mv.openSafariPage(with: news.url)
    }
    
    public func setArticle(article: article, mainView: mainViewController) {
        self.news       = article
        self.mainView   = mainView
        
        // Set Subviews
        let offset:CGFloat  = 15
        let width:CGFloat   = (.widthArticle - .spacingStack) - offset
        let height:CGFloat  = .heightScroll - offset * 2
        
        imageView.frame = CGRect(x: offset / 2,
                                 y: offset,
                                 width: width,
                                 height: height)
        
        lable.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lable.text = news.title
        
        lable.frame = CGRect(x: imageView.width * 0.1,
                             y: imageView.height * 0.35,
                             width: imageView.width * 0.8,
                             height: imageView.height * 0.6)
        
        viewShadow.frame                = imageView.frame
        viewShadow.layer.cornerRadius   = imageView.layer.cornerRadius
        
        
        // Set gradient layer
        let gradient = CAGradientLayer()
        gradient.frame          = imageView.bounds
        gradient.colors         = [CGColor.gradientColorStart, CGColor.gradientColorEnd]
        gradient.endPoint       = CGPoint(x: 0.5, y: 0)
        gradient.startPoint     = CGPoint(x: 0.5, y: 1)
        gradient.locations      = [0.0, 1.0]
        
        
        // Adding subviews
        addSubview(viewShadow)
        addSubview(imageView)
        imageView.layer.addSublayer(gradient)
        imageView.addSubview(lable)
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.articleTapped))
        imageView.addGestureRecognizer(tap)
        
        articlePresenter.shared.loadImage(with: news.urlToImage) { [weak self] image in
            guard let image = image else {
                DispatchQueue.main.async {
                    self?.imageView.image   = UIImage(named: "defaultNews")
                }
                return
            }
            self?.imageView.image   = image
        }
    }
}
