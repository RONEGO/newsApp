//
//  storageImages.swift
//  goraNews
//
//  Created by Yegor Geronin on 13.03.2022.
//

import Foundation

public class storageImages {
    
    static fileprivate func getURL() -> URL {
        let cachePath: FileManager.SearchPathDirectory = .cachesDirectory
        if let url = FileManager.default.urls(for: cachePath, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for cache!!")
        }
    }
    
    static func store(_ object: imagesInMemory, as fileName: String) {
        let url = getURL().appendingPathComponent(fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func retrieve(_ fileName: String, as type: imagesInMemory.Type) -> imagesInMemory {
        let url = getURL().appendingPathComponent(fileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("File at path \(url.path) does not exist!")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("No data at \(url.path)!")
        }
    }
    
    static func clear() {
        let url = getURL()
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
