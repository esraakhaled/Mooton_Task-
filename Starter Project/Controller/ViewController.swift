//
//  ViewController.swift
//  Starter Project
//
//  Created by Ahmed M. Hassan on 26/03/2023.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    private var collectionView: UICollectionView?
    //MARK: - Constants
    let urlString = "https://api.unsplash.com/photos/?client_id=I5zipqe38xZO91y218tdtn3VaiR4Qn4RGrBVvnmaTf8&order_by=ORDER&per_page=30"
    //MARK: - Variables
    var pictureInfo: [ImageInfo] = []
    var photoThumbnail: UIImage!
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchPhotos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    //MARK: -Functions
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    //Fetch a list of newly added images to unsplash api
    func fetchPhotos() {
        guard let url = URL(string: urlString) else {
            return
        }
        //I have used URLSession as 1st party APIs
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let jsonResult = try JSONDecoder().decode([ImageInfo].self, from: data)
                self.pictureInfo.append(contentsOf: jsonResult)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = pictureInfo[indexPath.row].urls.full
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURLString)
        //save images to cache
        DispatchQueue.main.async {
            cell.myImageView.loadImages(from: self.pictureInfo[indexPath.row].urls.fullUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //send url as string to another view controller when tapping on collectionView cell
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.imageUrl =  pictureInfo[indexPath.row].urls.full
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
