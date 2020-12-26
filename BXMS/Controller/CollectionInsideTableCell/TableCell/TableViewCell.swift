import UIKit
import RealmSwift



protocol CollectionViewCellDelegate: class {
    func collectionView(collectionviewcell: CollectionViewCell?, index: Int, didTappedInTableViewCell: TableViewCell)
    // other delegate methods that you can define to perform action in viewcontroller
}

class TableViewCell: UITableViewCell {
    
    weak var cellDelegate: CollectionViewCellDelegate?
    var data: Results<Data>!
    var objIndex: Int = 0
    var docName: String = ""
    
    
    var rowWithColors: [CollectionViewCellModel]?
    
    @IBOutlet var subCategoryLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        self.subCategoryLabel.textColor = UIColor.black
        data = realm.objects(Data.self)
        // TODO: need to setup collection view flow layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 150, height: 180)
        flowLayout.minimumLineSpacing = 2.0
        flowLayout.minimumInteritemSpacing = 5.0
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.showsHorizontalScrollIndicator = false
        
        // Comment if you set Datasource and delegate in .xib
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // Register the xib for collection view cell
        let cellNib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "collectionviewcellid")
    }
    
    func searchDocNameFromData() -> Bool {
        print(docName)
        for i in data.indices {
            if data[i].bookmarks.count != 0 {
                for j in data[i].bookmarks.indices {
                    if docName == data[i].bookmarks[j] {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func setScrollPosition(x: CGFloat) {
        collectionView.setContentOffset(CGPoint(x: x >= 0 ? x : 0, y: 0), animated: false)
    }

    func getScrollPosition() -> CGFloat {
        return collectionView.contentOffset.x
    }
}

extension TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // The data we passed from the TableView send them to the CollectionView Model
    func updateCellWith(row: [CollectionViewCellModel]) {
        self.rowWithColors = row
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        print("I'm tapping the \(indexPath.item)")
        self.cellDelegate?.collectionView(collectionviewcell: cell,
                                          index: indexPath.item,
                                          didTappedInTableViewCell: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rowWithColors?.count ?? 0
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func saveData(data: Data) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print(error)
        }
    }
    

    
    // Set the data for each cell (color and color name)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionviewcellid", for: indexPath) as? CollectionViewCell {
            var cellName = rowWithColors![indexPath.row].name.localized
            self.docName = cellName
            
            if searchDocNameFromData() {
                cell.bookMarkButton.setImage(UIImage(named: "filled_bookmark"), for: .normal)
            } else {
                cell.bookMarkButton.setImage(UIImage(named: "codicon_bookmark"), for: .normal)
            }

            cell.bookMarkButton.tag = indexPath.row
            
            if let a = cellName.lastIndex(of: ".") {
                cellName.removeSubrange(cellName.startIndex...a)
                if cellName.starts(with: " ") {
                    cellName.remove(at: cellName.startIndex)
                }
            }
            
            cell.nameLabel.text = cellName.replacingOccurrences(of: "_", with: " ").lowercased().capitalizingFirstLetter()
                        
            return cell
        }
        return UICollectionViewCell()
    }
    
    // Add spaces at the beginning and the end of the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
