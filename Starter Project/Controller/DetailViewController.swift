//
//  DetailViewController.swift
//  Starter Project
//
//  Created by Esraa Khaled   on 28/03/2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var fullScreenImage: UIImageView!
    //MARK: - Variables
    var imageUrl: String!
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //downloading image after tapping it from collectionview cell
        //Fullscreen Image
        guard let url = URL(string: imageUrl) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.fullScreenImage.image = image
            }
        }
        task.resume()
    }
}

