//
//  DatePickerCollectionViewCell.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/10/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class DatePickerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
//    var dayLabel: UILabel! // rgb(128,138,147)
//    var numberLabel: UILabel!
//    var monthLabel: UILabel!
    var darkColor = UIColor(red: 0, green: 22.0/255.0, blue: 39.0/255.0, alpha: 1)
    var highlightColor = UIColor(red: 0/255.0, green: 199.0/255.0, blue: 194.0/255.0, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.monthLabel.font = UIFont.boldSystemFont(ofSize: 8)
        self.monthLabel.textAlignment = .center
        
        //   dayLabel = UILabel(frame: CGRect(x: 5, y: 15, width: frame.width - 10, height: 20))
        self.dayLabel.font = UIFont.systemFont(ofSize: 8)
        self.dayLabel.textAlignment = .center
        
        //    numberLabel = UILabel(frame: CGRect(x: 5, y: 30, width: frame.width - 10, height: 40))
        self.numberLabel.font = UIFont.systemFont(ofSize: 15)
        self.numberLabel.textAlignment = .center
        
        //super.init(frame: frame)
        
        //        contentView.addSubview(dayLabel)
        //        contentView.addSubview(numberLabel)
        //        contentView.addSubview(monthLabel)
        contentView.backgroundColor = .white
        //contentView.layer.cornerRadius = 3
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1

        
    }
        
       // monthLabel = UILabel(frame: CGRect(x: 5, y: 05, width: frame.width - 10, height: 20))
    
    override var isSelected: Bool {
        didSet {
            dayLabel.textColor = isSelected == true ? .white : darkColor.withAlphaComponent(0.5)
            monthLabel.textColor = isSelected == true ? .white : darkColor.withAlphaComponent(0.5)
            numberLabel.textColor = isSelected == true ? .white : darkColor
            contentView.backgroundColor = isSelected == true ? highlightColor : .white
            contentView.layer.borderWidth = isSelected == true ? 0 : 1
        }
    }
    
    func populateItem(date: Date, highlightColor: UIColor, darkColor: UIColor) {
        self.highlightColor = highlightColor
        self.darkColor = darkColor
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        monthLabel.text = monthFormatter.string(from: date).uppercased()
        monthLabel.textColor = isSelected == true ? .white : darkColor.withAlphaComponent(0.5)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        dayLabel.text = dateFormatter.string(from: date).uppercased()
        dayLabel.textColor = isSelected == true ? .white : darkColor.withAlphaComponent(0.5)
        
        let numberFormatter = DateFormatter()
        numberFormatter.dateFormat = "d"
        numberLabel.text = numberFormatter.string(from: date)
        numberLabel.textColor = isSelected == true ? .white : darkColor
        
        contentView.layer.borderColor = darkColor.withAlphaComponent(0.2).cgColor
        contentView.backgroundColor = isSelected == true ? highlightColor : .white
    }

}
