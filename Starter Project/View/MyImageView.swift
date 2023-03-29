//
//  MyImageView.swift
//  Starter Project
//
//  Created by Esraa Khaled   on 29/03/2023.
//

import UIKit

class MyImageView: UIImageView {
    
    //MARK: - Variables
    static var cache = NSCache<AnyObject, UIImage>()
    var url: URL?
    //MARK: -Functions
    func loadImages(from url: URL) {
        self.url = url
        if let cachedImage = MyImageView.cache.object(forKey: url as AnyObject) {
            self.image = cachedImage
            print("You get image from cache")
        }else{
            URLSession.shared.dataTask(with: url) { (data, respnse, error) in
                if let error = error {
                    print("Error: \(error)")
                }else if let data = data {
                    if url == self.url{
                        DispatchQueue.main.async {
                            self.image = UIImage(data: data)
                            MyImageView.cache.setObject(self.image!, forKey: url as AnyObject)
                            print("You get image from \(url)")
                        }
                    }else{
                        print("1111")
                    }
                }
            }.resume()
        }
    }
}

