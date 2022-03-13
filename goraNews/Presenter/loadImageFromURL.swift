//
//  loadImageFromURL.swift
//  goraNews
//
//  Created by Yegor Geronin on 12.03.2022.
//

import Foundation
import UIKit

class articlePresenter {
    public static let shared = articlePresenter()
    
    public var cacheImage       = NSCache<NSString,UIImage>()
    
    public func loadImage(with url: String?, completion: @escaping (UIImage?) -> Void) {
        
        guard let urlString = url, let url = URL(string: urlString) else {
            print("Invalid image url!")
            completion(nil)
            return
        }
        if let image = cacheImage.object(forKey: NSString(string: urlString)) {
            completion(image)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _ , error in
            guard let data = data, error == nil else {
                print("Unable to download image! \(String(describing: error))")
                completion(nil)
                return
            }
            
            guard let image = UIImage(data: data) else {
                print("Unable to convert data to image :(")
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.cacheImage.setObject(image, forKey: NSString(string: urlString))
                completion(image)
            }
            
        }.resume()
    }
}
