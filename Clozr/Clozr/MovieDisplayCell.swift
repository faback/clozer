//
//  MovieDisplayCell.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/7/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

@objc protocol MovieDisplayCellDelegate{
    func MovieDisplayCellDelegate(str:String, tableSectionNum: Int)
}

class MovieDisplayCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var movieTimingsCollectionVIew: UICollectionView!
    var showTimings = [String]()
    var sectionNum: Int!
    var delegate: MovieDisplayCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        movieTimingsCollectionVIew.dataSource = self
        movieTimingsCollectionVIew.delegate = self
        //movieTimingsCollectionVIew.isScrollEnabled = false
        movieTimingsCollectionVIew.allowsMultipleSelection = false
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showTimings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieTimingsCollectionVIew.dequeueReusableCell(withReuseIdentifier: "MovieTimingCollectionCell", for: indexPath) as! MovieTimingsCollectionCell
        cell.movieTimingLabel.text = showTimings[indexPath.row]
        cell.layer.cornerRadius = 5
        cell.backgroundColor = UIColor(red: 57.0/255.0, green: 101.0/255.0, blue: 169.0/255.0, alpha:0.8)
        cell.movieTimingLabel.textColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = movieTimingsCollectionVIew.cellForItem(at: indexPath) as! MovieTimingsCollectionCell
//        cell?.layer.borderWidth = 2.0
//        cell?.layer.borderColor = UIColor.gray.cgColor
        delegate?.MovieDisplayCellDelegate(str: showTimings[indexPath.row], tableSectionNum: sectionNum)
        
//        cell.backgroundColor = UIColor(red: 57.0/255.0, green: 101.0/255.0, blue: 169.0/255.0, alpha:1)
//        cell.movieTimingLabel.textColor = UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = movieTimingsCollectionVIew.cellForItem(at: indexPath) as! MovieTimingsCollectionCell
        //cell?.layer.borderWidth = 0.0
//        cell.backgroundColor = UIColor.white
//        cell.movieTimingLabel.textColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
