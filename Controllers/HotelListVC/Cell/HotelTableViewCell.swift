//
//  HotelTableViewCell.swift
//  My Hotels
//
//  Created by Prashant Devera on 10/12/22.
//

import UIKit

class HotelTableViewCell: UITableViewCell {

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
            
            self.loadImage(url: "\(self.objHotel?.media?.first ?? "")?downsize=1200:628")
            self.lblHotelName.text = objHotel?.name
            self.lblHotelType.text = "\(objHotel?.starRating ?? 0) \(NSLocalizedString("star", comment: "")) \(objHotel?.propertyType ?? "")"
            self.lblLocation.text = "\(objHotel?.locationDetail?.name ?? ""), \(objHotel?.locationDetail?.countryName ?? "")"
            let locale = NSLocale.current.languageCode
            self.lblDesc.text = locale == "en" ? objHotel?.desc : objHotel?.desc_spanish
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.layer.borderColor = UIColor.gray.cgColor
        viewContainer.layer.borderWidth = 1.0
        viewContainer.layer.cornerRadius = 5.0
        
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 5.0

        self.viewContainer.layer.shadowColor = UIColor.black.cgColor
        self.viewContainer.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.viewContainer.layer.shadowRadius = 2.0
        self.viewContainer.layer.shadowOpacity = 0.5
        self.viewContainer.layer.masksToBounds = false

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
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
