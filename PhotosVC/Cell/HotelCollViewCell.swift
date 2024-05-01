//
//  HotelCollViewCell.swift
//  My Hotels
//
//  Created by My Hotels on 06/12/22.
//

import UIKit

class HotelCollViewCell: UICollectionViewCell {
    
    //Outlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblHotelType: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    //Loading an image in imageview
    var objHotel: ModelHotel? {
        didSet {
            DispatchQueue.main.async {
                let url = URL(string: "\(self.objHotel?.media?.first?.url ?? "")?downsize=1200:628")!
                self.imgView.kf.setImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        self.imgView.image = value.image
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
            self.lblHotelName.text = objHotel?.name
            self.lblHotelType.text = objHotel?.propertyType
            self.lblLocation.text = "\(objHotel?.locationDetail?.name ?? ""), \(objHotel?.locationDetail?.countryName ?? "")"
            self.lblDesc.text = "\(objHotel?.desc ?? "")"
        }
    }
    
    
    override func awakeFromNib() {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
        imgView.layer.cornerRadius = 5.0
        viewContainer.layer.cornerRadius = 5.0
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
}
