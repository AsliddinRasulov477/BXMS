//
//  AnotherAppsController.swift
//  3003
//
//  Created by Asliddin Rasulov on 28/10/20.
//

import UIKit

class AnotherAppsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var appNames = ["plan_schotov", "bxms", "svod_zakonov", "buxgalterskiy_pravodki", "ekzaminator_buxgaltera"]
    
    var descriptions = ["Эта программа бухгалтерского учета и быстро получить информацию из некоторых...", "В приложении пользователь имеет доступ ко всем Национальным Стандартам Бухгалтерского учета...", "Приложение - список кодексов. Пользователь может ознакомиться и выбрать нужные...", "Эта программа предназначена для лучшего понимания концепций узбекских бухгалтерских проводок и...", "Данное приложение поможет вам закрепить и проверить ваши знания по бухгалтерии...."]

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
}

extension AnotherAppsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "anotherAppsCell", for: indexPath) as! AnotherAppsCell
        cell.imageApp.image = UIImage(named: appNames[indexPath.row])
        cell.nameApp.text = appNames[indexPath.row].localized
        cell.descriptionApp.text = descriptions[indexPath.row]
        
        return cell
        
    }
    
    
}
