//
//  DetailsViewController.swift
// My Hotels
//
//  Created by My Hotels on 06/12/22.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {

    //MARK: - Outlets -
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tagView: TagListView!
    @IBOutlet weak var stkViewCategories: UIStackView!
    @IBOutlet weak var btnFavorite: UIButton!
    
    //MARK: - Variable Declaration -
    var objHotel: ModelHotel?

    
    //MARK: - ViewControllers Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    func setupData() {
        self.navigationItem.title = objHotel?.name
        self.lblTitle.text = objHotel?.name
        
        let locale = NSLocale.current.languageCode
        self.lblDesc.text = locale == "en" ? objHotel?.desc : objHotel?.desc_spanish

        self.pageControl.numberOfPages = self.objHotel?.media?.count ?? 0
        
        self.btnFavorite.setTitle(objHotel?.isFavorite == true ? NSLocalizedString("Remove From Favorites", comment: "") : NSLocalizedString("Add To Favorite", comment: ""), for: .normal)
        
        self.btnFavorite.layer.cornerRadius = 10.0
        self.tagView.cornerRadius = 8.0
        tagView.textFont = UIFont.systemFont(ofSize: 14)
        tagView.removeAllTags()
        if let categories = objHotel?.categories  {
            for strCategory in categories {
                self.tagView.addTag(strCategory)
            }
        } else {
            self.stkViewCategories.isHidden = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            let detailsVC = segue.destination as! MapViewController
            detailsVC.objHotel = objHotel
        }
    }
    //MARK: - IBAction - 
    @IBAction func actionFavorite(_ sender: UIButton) {
        self.updateData(id: objHotel?.id ?? "", isFavorite: !(objHotel?.isFavorite ?? false))
    }
    
    //MARK: - Update To Core Data -
    func updateData(id: String, isFavorite: Bool) {
        
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
                self.objHotel?.isFavorite = isFavorite
                self.setupData()
            } catch let error as NSError {
                debugPrint(error)
            }
        } catch let error as NSError {
            debugPrint(error)
        }
    }
}


//MARK: - UICollectionView Datasource and Delegates -
extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objHotel?.media?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollViewCell", for: indexPath) as? DetailsCollViewCell else {
            return UICollectionViewCell()
        }
        cell.loadImage(url: self.objHotel?.media?[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = collectionView.bounds.width
        return CGSize(width: screenWidth, height: screenWidth);
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

