//
//  FavoriteVC.swift
//  My Hotels
//
//  Created by My Hotels on 09/12/22.
//

import UIKit
import CoreData

class FavoriteVC: UIViewController {

    
    //MARK: - Variable Declaration -
    var arrHotels = [ModelHotel]()
    var storage = HotelStorage()
    
    //MARK: - Outlets -
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - UIViewController Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Favorites", comment: "")
        let appearance = UINavigationBarAppearance()
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromCoreData()
    }
    
    //MARK: - Fetching Data from JSON and Core Data -
    func fetchDataFromCoreData() {
        storage.retriveData(isFavorite: true) { result in
            if let array = result, result?.count != 0 {
                self.arrHotels = array
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                self.arrHotels = []
                self.tableView.reloadData()
            }
        }
    }
    
    //Perform segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            if let indexPath = tableView.indexPathsForSelectedRows?.first {
                let obj = arrHotels[indexPath.row]
                let detailsVC = segue.destination as! DetailsViewController
                detailsVC.objHotel = obj
            }
        }
    }

}

//MARK: - UICollectionView Datasource and Delegates & Context menu -
extension FavoriteVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrHotels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCollViewCell", for: indexPath) as? HotelCollViewCell else {
            return UICollectionViewCell()
        }
        cell.objHotel = self.arrHotels[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = collectionView.bounds.width - 20
        return CGSize(width: screenWidth, height: screenWidth);
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemAt indexPath: IndexPath,
                                 point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let hotel = self.arrHotels[indexPath.row]
            
            let mapAction =
            UIAction(title: NSLocalizedString("Show in map", comment: ""),
                     image: UIImage(named: "imgLocation")) { action in
                self.showOnMap(hotel: hotel)
            }
            
            let strFavorite = hotel.isFavorite == true ? NSLocalizedString("Remove From Favorites", comment: "") : NSLocalizedString("Add To Favorite", comment: "")
            
            let favoriteAction =
            UIAction(title: NSLocalizedString(strFavorite, comment: ""),
                     image: UIImage(named: "favorite_fill")) { action in
                self.addToFavorite(hotel: hotel, indexPath: indexPath)
            }
            
            let shareAction =
            UIAction(title: NSLocalizedString("Share", comment: ""),
                     image: UIImage(named: "ic_share")) { action in
                self.shareAction(hotel: hotel)
            }
            return UIMenu(title: "", children: [mapAction, favoriteAction, shareAction])
        }
    }
    
    //Contex Menu Operations
    func showOnMap(hotel: ModelHotel) {
        let mapVC = self.storyboard?.instantiateViewController(identifier: "MapViewController") as! MapViewController
        mapVC.objHotel = hotel
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func shareAction(hotel: ModelHotel) {
        // text to share
        let strName = hotel.name ?? ""
        let strDesc = hotel.desc ?? ""
        
        // set up activity view controller
        let textToShare = [strName, strDesc]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func addToFavorite(hotel: ModelHotel, indexPath: IndexPath) {
        updateData(id: hotel.id ?? "", isFavorite: !hotel.isFavorite!, indexPath: indexPath)
    }
    
    //Update the data in Core Data
    func updateData(id: String, isFavorite: Bool, indexPath: IndexPath) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let  fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Hotel")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            guard let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else {
                return
            }
            guard let objc = result.first else { return }
            objc.setValue(isFavorite, forKey: "isFavorite")
            do {
                try managedContext.save()
                debugPrint("Data Updated")
                self.arrHotels.remove(at: indexPath.row)
                self.tableView.reloadData()
            } catch let error as NSError {
                debugPrint(error)
            }
        } catch let error as NSError {
            debugPrint(error)
        }
    }
}


//MARK: - UITableView Datasource and Delegates & Context menu -
extension FavoriteVC: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrHotels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelTableViewCell") as? HotelTableViewCell else {
            return UITableViewCell()
        }
        cell.objHotel = self.arrHotels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let hotel = self.arrHotels[indexPath.row]
            
            let mapAction =
            UIAction(title: NSLocalizedString("Show in map", comment: ""),
                     image: UIImage(named: "imgLocation")) { action in
                self.showOnMap(hotel: hotel)
            }
            
            let strFavorite = hotel.isFavorite == true ? NSLocalizedString("Remove From Favorites", comment: "") : NSLocalizedString("Add To Favorite", comment: "")
            
            let favoriteAction =
            UIAction(title: NSLocalizedString(strFavorite, comment: ""),
                     image: UIImage(named: "favorite_fill")) { action in
                self.addToFavorite(hotel: hotel, indexPath: indexPath)
            }
            
            let shareAction =
            UIAction(title: NSLocalizedString("Share", comment: ""),
                     image: UIImage(named: "ic_share")) { action in
                self.shareAction(hotel: hotel)
            }
            return UIMenu(title: "", children: [mapAction, favoriteAction, shareAction])
        }
    }
}
