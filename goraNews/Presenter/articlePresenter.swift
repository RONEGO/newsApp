//
//  loadImageFromURL.swift
//  goraNews
//
//  Created by Yegor Geronin on 12.03.2022.
//

import Foundation
import UIKit

typealias cachedData = NSCache<NSString,UIImage>

class articlePresenter {
    public static let shared    = articlePresenter()
    
    private var imagesInRam         = cachedData()
    private var cacheInMemory       = imagesInMemory(images: [imageInMemory]())
    
    public func loadImage(with url: String?, completion: @escaping (UIImage?) -> Void) {
        
        guard let urlString = url, let url = URL(string: urlString) else {
            print("Invalid image url!")
            completion(nil)
            return
        }
        if let image = imagesInRam.object(forKey: NSString(string: urlString)) {
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
            
            let queue = DispatchQueue.global(qos: .utility)
            
            queue.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.imagesInRam.setObject(image,
                                                forKey: NSString(string: urlString))
                strongSelf.addData(with: urlString, imageForSave: image)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
        }.resume()
    }
    
    public func getData() {
        
        let cacheInMemory = storageImages.retrieve(.cacheImage, as: imagesInMemory.self)
        print("Total count saved: ", cacheInMemory.images.count)
        for image in cacheInMemory.images {
            guard let imageUI = UIImage(data: image.image) else {
                continue
            }
            imagesInRam.setObject(imageUI, forKey: NSString(string: image.url))
        }
    }
    
    private func addData(with url: String, imageForSave image: UIImage) {
        cacheInMemory.addNewImage(with: url, imageForSave: image)
    }
    
    public func saveData() {
        storageImages.store(cacheInMemory, as: .cacheImage)
    }
}

struct imagesInMemory: Codable {
    var images: [imageInMemory]
    public mutating func addNewImage(with url: String, imageForSave image: UIImage) {
        guard let data = image.pngData() else {
            return
        }
        images.append(imageInMemory(url: url, image: data))
    }
}

struct imageInMemory: Codable{
    var url:    String
    var image:  Data
}
