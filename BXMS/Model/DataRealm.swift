//
//  DataRealm.swift
//  bxms
//
//  Created by Coder on 09/10/20.
//  Copyright © 2020 Coder. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var allBHMS: String = ""
    let bookmarks = List<String>()
    convenience init(bookmark: String) {
        self.init()
        self.bookmarks.append(bookmark)
    }
}
