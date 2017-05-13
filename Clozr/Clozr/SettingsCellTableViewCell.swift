//
//  SettingsCellTableViewCell.swift
//  Clozr
//
//  Created by CK on 5/7/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class SettingsCellTableViewCell: UITableViewCell {
    @IBOutlet weak var settingsImage: UIImageView!
    @IBOutlet weak var settingsName: UILabel!
    
    @IBOutlet weak var settingSwitch: UISwitch!
    
    
    var indexRow:Int?
    
    var settings:Settings!  {
        didSet {
            if(settings != nil) {
                layoutSetting()
            }
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func tintImage() {
        let origImage = UIImage(named: settings.icon!)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        settingsImage.image = tintedImage
        settingsImage.tintColor = UIColor.black
        
    }
    
    
    func layoutSetting() {
        tintImage()
        settingsName.text = settings.name
    }
    
 }
