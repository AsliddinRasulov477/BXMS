import UIKit
import RealmSwift


class BookmarksController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataToStringArray: [String] = []
    
    var searchResults: [String] = []
    var isSearching: Bool = false
    
    var data: Results<Data>!
    
    var searchController = UISearchController(searchResultsController: nil)
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = realm.objects(Data.self)
//        data = data.sorted(byKeyPath: "nameBookmark")
        navigationItem.hidesSearchBarWhenScrolling = false
        setSearchController(searchController: searchController, delegate: self)
    }
    
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.title = "bookmarked".localized
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: view.frame.height / 30)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        
        setSearchController(searchController: searchController, delegate: self)
        
        data = realm.objects(Data.self)
        
//        data = data.sorted(byKeyPath: "nameBookmark")
        
        dataToStringArray = []
        
        for i in data.indices {
//            dataToStringArray.append(data[i].nameBookmark)
        }
        print(dataToStringArray)
        tableView.reloadData()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookmark" {
            let vc = segue.destination as! DetailsViewController
//            vc.docName = (data[tableView.indexPathForSelectedRow!.row].nameBookmark)
        }
    }
}


//MARK: Table
extension BookmarksController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchResults.count
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarksCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "Gill Sans", size: 20)
        
        var cellName = ""//data[indexPath.row].nameBookmark
        
        if let a = cellName.lastIndex(of: ".") {
            cellName.removeSubrange(cellName.startIndex...a)
            
            if cellName.starts(with: " ") {
                cellName.remove(at: cellName.startIndex)
            }
            cell.textLabel?.text = cellName.replacingOccurrences(of: "_", with: " ").lowercased().capitalizingFirstLetter()
        }
        
        if isSearching {
            var cellNameWhenSearching = searchResults[indexPath.row]
            
            if let a = cellNameWhenSearching.lastIndex(of: ".") {
                cellNameWhenSearching.removeSubrange(cellNameWhenSearching.startIndex...a)
                cell.textLabel?.text = cellNameWhenSearching.replacingOccurrences(of: "_", with: " ").lowercased().capitalizingFirstLetter()
            }
            
        } else {
            cell.textLabel?.text = cellName.replacingOccurrences(of: "_", with: " ").lowercased().capitalizingFirstLetter()
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            do {
                try realm.write {
                    realm.delete(data[indexPath.row])
                }
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
    }
}



//MARK: Search

extension BookmarksController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        
        if searchBar.text == "" {
            isSearching = false
        }

        self.searchResults = dataToStringArray.containsStringArray(searchText: searchText, existingArray: dataToStringArray)
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
}
