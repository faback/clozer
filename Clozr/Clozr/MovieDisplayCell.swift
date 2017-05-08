//
//  MovieDisplayCell.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/7/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class MovieDisplayCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var movieTimingsCollectionVIew: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        movieTimingsCollectionVIew.dataSource = self
        movieTimingsCollectionVIew.delegate = self
        movieTimingsCollectionVIew.isScrollEnabled = false
        movieTimingsCollectionVIew.allowsMultipleSelection = false
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieTimingsCollectionVIew.dequeueReusableCell(withReuseIdentifier: "MovieTimingCollectionCell", for: indexPath) as! MovieTimingsCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = movieTimingsCollectionVIew.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.gray.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = movieTimingsCollectionVIew.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
