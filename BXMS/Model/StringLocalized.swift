import UIKit


extension String {
    var localized: String {
        return NSLocalizedString(self,
                                 tableName: nil,
                                 bundle: LocalizationSystem.shared.bundle,
                                 comment: "")
    }
}
