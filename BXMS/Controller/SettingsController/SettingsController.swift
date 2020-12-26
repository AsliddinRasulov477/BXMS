//
//  MenuController.swift
//  3000
//
//  Created by Asliddin Rasulov on 02.10.2020.
//  Copyright © 2020 Asliddin Rasulov. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var settingsName: [String] = ["til", "tun", "bolishish", "bizbaho", "bizhaqim", "bizilova"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = view.frame.height * 0.5 / 6
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateLocalizatsiya()
    }

}

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableCell
        
        cell.settingsLabel.font = UIFont.systemFont(ofSize: view.frame.height / 45)
        cell.settingsLabel.text = settingsName[indexPath.row].localized
        cell.imageView?.image = UIImage(named: settingsName[indexPath.row])
        if indexPath.row == 1 {
            cell.darkMode.isHidden = false
        } else {
            cell.darkMode.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "lang") as! LanguageViewController
            vc.title = "til".localized
            self.navigationController?.pushViewController(vc, animated: true)
        } else
        if indexPath.row == 5 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "anotherApp") as! AnotherAppsController
            vc.title = "bizilova".localized
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateLocalizatsiya() {
        navigationItem.title = "settings".localized
        tableView.reloadData()
    }
}


class SettingsTableCell: UITableViewCell {
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsIcon: UIImageView!
    @IBOutlet weak var darkMode: UISwitch!
}
