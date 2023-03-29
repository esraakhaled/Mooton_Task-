//
//  ImageCollectionViewCell.swift
//  Starter Project
//
//  Created by Esraa Khaled   on 28/03/2023.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    let myImageView: MyImageView = {
        let image = MyImageView()
        return image
    }()
    
    //MARK: - Constants
    static let identifier = "ImageCollectionViewCell"
    
    //MARK: -Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(myImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        myImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.image = nil
    }
    
    //MARK: -Functions
    func configure(with urlString: String){
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.myImageView.image = image
            }
        }
        task.resume()
    }
}
