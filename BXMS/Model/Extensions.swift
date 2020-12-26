import Foundation
import UIKit



extension UISearchBar {
    
    func changeSearchBarColor(color: UIColor) {
        let attributes:[NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 35)
        UIGraphicsBeginImageContext(frame.size)
        color.setFill()
        UIBezierPath(rect: frame).fill()
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.setSearchFieldBackgroundImage(makeRoundedImage(image: bgImage, radius: 15), for: .normal)
    }
    
    func makeRoundedImage(image: UIImage, radius: Float) -> UIImage {
        let imageLayer: CALayer = CALayer()
        imageLayer.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        imageLayer.contents = (image.cgImage as AnyObject)
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = 10
        UIGraphicsBeginImageContext(image.size)
        imageLayer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return roundedImage
    }
}


extension UIViewController {
    func setSearchController(searchController: UISearchController, delegate: UISearchBarDelegate) {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = delegate
        searchController.searchBar.placeholder = "search".localized
        searchController.searchBar.changeSearchBarColor(color: .white)
        searchController.searchBar.tintColor = .black
    }
}



extension UIColor {
    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
    }
    
    static func colorFromHex(_ hex: String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        if hexString.count != 6 {
            return UIColor.magenta
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        return UIColor(red: CGFloat((rgb & 0xFF0000) >> 16) / 255,
                       green: CGFloat((rgb & 0x00FF00) >> 8) / 255,
                       blue: CGFloat(rgb & 0x0000FF) / 255,
                       alpha: 1.0)
    }
}


extension Array {
    func containsStringDoubleArray(searchText: String, existingDoubleArray: [[String]]) -> [String] {
        var array: [String] = []
        var doubleArraytoArray: [String] = []
        let boolDoubleArray = existingDoubleArray.flatMap { $0.map { $0.lowercased().contains(searchText.lowercased()) } }
    
        doubleArraytoArray = existingDoubleArray.flatMap { $0 }
    
        for i in 0..<boolDoubleArray.count {
            if boolDoubleArray[i] {
                array.append(doubleArraytoArray[i])
            }
        }
        return array
    }
    
    func containsStringArray(searchText: String, existingArray: [String]) -> [String] {
        var array: [String] = []
        let boolDoubleArray = existingArray.map{ $0.lowercased().contains(searchText.lowercased())}
    
        for i in 0..<boolDoubleArray.count {
            if boolDoubleArray[i] {
                array.append(existingArray[i])
            }
        }
        return array
    }
}
