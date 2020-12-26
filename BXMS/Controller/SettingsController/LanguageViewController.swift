//
//  SettingsViewController.swift
//  bxms
//
//  Created by Coder on 09/10/20.
//  Copyright © 2020 Coder. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let appSettings = AppSettings.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "settings".localized
        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Langs.allCases.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        let langs = Langs.allCases[indexPath.row].title()
        
        if appSettings.langs == Langs.allCases[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = langs
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentLang = Langs.allCases[indexPath.row]
        appSettings.langs = currentLang
        LocalizationSystem.shared.locale =
            Bundle.main.localizations.filter { $0 != "Base" }.map { Locale(identifier: $0) }[currentLang.rawValue + 1]
        navigationItem.title = "settings".localized
        self.tableView.reloadData()
    }
}
