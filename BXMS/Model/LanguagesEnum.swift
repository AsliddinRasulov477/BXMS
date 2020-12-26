//
//  LanguagesEnum.swift
//  bxms
//
//  Created by coder on 24/10/20.
//  Copyright © 2020 Coder. All rights reserved.
//

import Foundation


public enum Langs: Int, CaseIterable {
  case uzCyrl
  case ru
  case uz
  
  public func title() -> String {
    switch self {
    case .uzCyrl: return "Узбек тили"
    case .ru: return "Русский"
    case .uz: return "O'zbek tili"
    }
  }
}


public class AppSettings{
  
  private struct Keys {
    static let questionStrategy = "saveLanguage"
  }
  
  public static let shared = AppSettings()
  
  public var langs: Langs {
    get {
      let rawValue = userDefaults.integer(forKey: Keys.questionStrategy)
      return Langs(rawValue: rawValue)!
    }
    set {
      userDefaults.set(newValue.rawValue, forKey: Keys.questionStrategy)
    }
  }
  private let userDefaults = UserDefaults.standard
  
  private init() { }
}
