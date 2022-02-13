//
//  ViewController.swift
//  PhotoSearch
//
//  Created by Anton on 31.01.2022.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    
    
    
    
    
    private var collectionView:UICollectionView?
    
    let searchBar = UISearchBar()
    
    
    var results:[Result] = []
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.addSubview(searchBar)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
        
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(imageCollectionViewCell.self, forCellWithReuseIdentifier: imageCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        
        
        view.addSubview(collectionView)
        self.collectionView = collectionView
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(AttributedString.init("Введите ключевое слово(прим. Cycle)"))

        
    }
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.frame.size.width, height: view.frame.size.height-55)
    }
    //MARK: - SearchBarMethods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            results = []
            collectionView?.reloadData()
            fetchPhotos(query: text)
        }
    }
    // MARK: - fetchPhotos
    func fetchPhotos(query:String) {
        let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=\(query)&client_id=UpXsjVKAWnWskKGTnw2HAiONgeAwdbiczwkNUn9ftRg"
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self]data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.results = jsonResult.results
                    self?.collectionView?.reloadData()
                    
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
    //MARK: - CollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = results[indexPath.row].urls.regular
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCollectionViewCell.identifier, for: indexPath) as? imageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURLString)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    
    
}

