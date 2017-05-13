//
//  SettingsViewController.swift
//  Clozr
//
//  Created by CK on 5/7/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var settingsTable: UITableView!

    var settings:[Int:[Settings]] = [Int:[Settings]]()
    var sections:[Int:String] = [Int:String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]

        sections[0] = "General"
        let settingsGeneral = Settings.getSettings(forSection: sections[0]!)
        settings[0] = settingsGeneral
        settingsTable.delegate = self
        settingsTable.dataSource = self
        
        settingsTable.reloadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



extension SettingsViewController: UITableViewDelegate , UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  settingsCell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as! SettingsCellTableViewCell
        let settingsArray = settings[indexPath.section]
        let setting = settingsArray?[indexPath.row]
        settingsCell.settings = setting
        return settingsCell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentSettings = settings[section] {
            return currentSettings.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
    
    
}
