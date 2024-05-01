//
//  DetailsCollViewCell.swift
//  My Hotels
//
//  Created by My Hotels on 08/12/22.
//

import UIKit

class DetailsCollViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    func loadImage(url: String?) {
        DispatchQueue.main.async {
            let url = URL(string: "\(url ?? "")?downsize=1200:628")!
            self.imgView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.imgView.image = value.image
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}
