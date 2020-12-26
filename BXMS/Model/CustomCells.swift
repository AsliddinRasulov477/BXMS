import Foundation
import UIKit


class AnotherAppsCell: UITableViewCell {
    @IBOutlet weak var imageApp: UIImageView!
    @IBOutlet weak var nameApp: UILabel!
    @IBOutlet weak var descriptionApp: UILabel!
    
    
    override var frame: CGRect {
        get {
            return super.frame
        } set (newFrame) {
            var frame = newFrame
            frame.origin.x += 10
            frame.size.width -= 20
            frame.origin.y += 5
            frame.size.height -= 10
            super.frame = frame
        }
    }
}
