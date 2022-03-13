//
//  cellHeaderView.swift
//  goraNews
//
//  Created by Yegor Geronin on 12.03.2022.
//

import UIKit

class cellHeaderView: UIView {
    
    private let label = UILabel()
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        label.text = title
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        addSubview(label)
        
        label.frame = CGRect(x: width * 0.1,
                             y: .heightHeader / 4,
                             width: width * 0.9,
                             height: .heightHeader / 2)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
