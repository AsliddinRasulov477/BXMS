import UIKit
import RealmSwift

class TableView: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var docsArray = DocStruct()
    var tappedCell: CollectionViewCellModel!
    
    var data: Results<Data>?
    
    //offset for collection cells
    var offsets = [IndexPath:CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = realm.objects(Data.self)
        
        if data?.count == 0 {
            for doc in docsArray.docsArray {
                let newData = Data()
                newData.allBHMS = doc.category.localized
                do {
                    try realm.write {
                        realm.add(newData)
                    }
                } catch {
                    print(error)
                }
            }
        }
        
        navigationItem.largeTitleDisplayMode = .never
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = .systemGray5
        } else {
            tableView.backgroundColor = .lightGray
        }
        tableView.separatorStyle = .singleLine
        
        // Register the xib for tableview cell
        let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "tableviewcellid")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        navigationItem.title = "НСБУ".localized
    }
    
}

extension TableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return docsArray.docsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docsArray.docsArray[section].subcategory.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // Category Title
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        if #available(iOS 13.0, *) {
            headerView.backgroundColor = .systemGray5
        } else {
            headerView.backgroundColor = .lightGray
        }
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 0, width: 200, height: 44))
        headerView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = docsArray.docsArray[section].category.localized
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    ///fix the scrolling position of cells when dequeueing
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewcellid", for: indexPath) as? TableViewCell
        offsets[indexPath] = cell?.getScrollPosition()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewcellid", for: indexPath) as? TableViewCell {
            cell.setScrollPosition(x: offsets[indexPath] ?? 0)
            /// Show SubCategory Title
            ///remove
            let subCategoryTitle = docsArray.docsArray[indexPath.section].subcategory
            let subCat = subCategoryTitle[indexPath.row].localized

            cell.subCategoryLabel.text = subCat
            
            // Pass the data to colletionview inside the tableviewcell
            let rowArray = docsArray.docsArray[indexPath.section].documentName[indexPath.row]
            cell.updateCellWith(row: rowArray)
            
            // Set cell's delegate
            cell.cellDelegate = self
            cell.collectionView.reloadData()
            cell.selectionStyle = .none
            return cell
       }
        return UITableViewCell()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsviewcontrollerseg" {
            let DestViewController = segue.destination as! DetailsViewController
            DestViewController.backgroundColor = .white
            DestViewController.docName = tappedCell.name.localized
            DestViewController.categoryIndex = tappedCell.indexCell - 1
        }
    }
}

extension TableView: CollectionViewCellDelegate {
    func collectionView(collectionviewcell: CollectionViewCell?, index: Int, didTappedInTableViewCell: TableViewCell) {
        if let colorsRow = didTappedInTableViewCell.rowWithColors {
            self.tappedCell = colorsRow[index]
            performSegue(withIdentifier: "detailsviewcontrollerseg", sender: self)
            // You can also do changes to the cell you tapped using the 'collectionviewcell'
            
            
        }
    }
}
