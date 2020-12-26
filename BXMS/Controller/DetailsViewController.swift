import Foundation
import UIKit
import PDFKit
import RealmSwift



class DetailsViewController: UIViewController, SaveTheMemorySearch {
    
    var backgroundColor: UIColor!
    
    @IBOutlet weak var bookMark: UIBarButtonItem!
    
    var pdfView = PDFView()
    var docName: String = ""
    var memorySearchText: String = ""
    var categoryIndex: Int = 0
    
    var data: Results<Data>!
    var objIndex: Int = 0
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        data = realm.objects(Data.self)
        
        if searchDocNameFromData() {
            bookMark.image = UIImage(named: "filled_bookmark")
        } else {
            bookMark.image = UIImage(named: "codicon_bookmark")
        }
        
        displayPdf()
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
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if searchDocNameFromData() {
            bookMark.image = UIImage(named: "filled_bookmark")
        } else {
            bookMark.image = UIImage(named: "codicon_bookmark")
        }
        
    }
    
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func searchButtonOnTap(_ sender: UIBarButtonItem) {
        
        for index in 0..<pdfView.document!.pageCount {
            let page: PDFPage = pdfView.document!.page(at: index)!
            let annotations = page.annotations
            for annotation in annotations {
                page.removeAnnotation(annotation)
            }
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "search") as! SearchFromPDFController
        vc.pdfView = pdfView
        vc.searchText = memorySearchText
        vc.theMemorySearchDelegate = self
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func saveToBookmarks(_ sender: UIBarButtonItem) {
        if searchDocNameFromData() {
            do {
                try realm.write {
                    data[categoryIndex].bookmarks.remove(at: objIndex)
                }
            } catch {
                print(error)
            }
            
            sender.image = UIImage(named: "codicon_bookmark")
        } else {
            
            do {
                try realm.write {
                    data[categoryIndex].bookmarks.append(docName.localized)
                }
            } catch {
                fatalError()
            }
            
            
            sender.image = UIImage(named: "filled_bookmark")
        }
        
    }
    
    @IBAction func shareButtonOnTap(_ sender: UIBarButtonItem) {
        
        if let message = resourceUrl(forFileName: docName) {
            let objectsToShare = [message]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
    private func resourceUrl(forFileName fileName: String) -> URL? {
        
        if let resourceUrl = Bundle.main.url(forResource: fileName, withExtension: "pdf") {
            return resourceUrl
        }
        
        return nil
    }
    
    private func createPdfView(withFrame frame: CGRect) -> PDFView {
        
        let pdfView = PDFView(frame: frame)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return pdfView
    }
    
    private func createPdfDocument(forFileName fileName: String) -> PDFDocument? {
        
        if let resourceUrl = self.resourceUrl(forFileName: fileName) {
            return PDFDocument(url: resourceUrl)
        }
        return nil
    }
    
    private func displayPdf() {
        pdfView = self.createPdfView(withFrame: self.view.bounds)
        if let pdfDocument = self.createPdfDocument(forFileName: docName) {
            self.view.addSubview(pdfView)
            pdfView.autoScales = true
            pdfView.document = pdfDocument
        }
        
    }
    
    @objc func hideTabBarOnTapPDFview() {
        
        if tabBarController!.tabBar.isHidden {
            tabBarController?.tabBar.isHidden = false
        } else {
            tabBarController?.tabBar.isHidden = true
        }
        
    }
    
    func saveTheWordWhenCancelPressed(mem: String) {
        memorySearchText = mem
    }
    
    func searchDocNameFromData() -> Bool {
        for i in data[categoryIndex].bookmarks.indices {
            if docName == data[categoryIndex].bookmarks[i] {
                objIndex = i
                return true
            }
        }
        return false
    }
}


