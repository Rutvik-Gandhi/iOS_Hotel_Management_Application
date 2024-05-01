//
//  PhotosViewController.swift
// My Hotels
//
//  Created by My Hotels on 06/12/22.
//

import UIKit

class HotelListingVC: UIViewController {

    //MARK: - Variable Declaration -
    var arrHotels = [ModelHotel]()
    var storage = HotelStorage()
    
    
    //MARK: - Outlets -
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - ViweController Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Places"
        let appearance = UINavigationBarAppearance()
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Get Places", style: .plain, target: self, action: #selector(self.loadHotels))
        loadHotels()
    }
    
    //MARK: - Fetching Photos from JSON -
    @objc func loadHotels() {
        storage.fetchAllImages { result in
            
            if let array = result {
                self.arrHotels = array
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                let alert = UIAlertController(title: "My Hotels", message: "Failed to fetch record.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                    self.loadHotels()
                }))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let obj = arrHotels[indexPath.row]
                let detailsVC = segue.destination as! DetailsViewController
                detailsVC.objIimage = obj
            }
        }
    }
}


//MARK: - UICollectionView Datasource and Delegates -
extension HotelListingVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
}
