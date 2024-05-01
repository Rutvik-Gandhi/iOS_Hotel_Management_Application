//
//  DetailsViewController.swift
// My Hotels
//
//  Created by My Hotels on 06/12/22.
//

import UIKit

class DetailsViewController: UIViewController {

    //MARK: - Outlets -
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //MARK: - Variable Declaration -
    var objIimage: ModelHotel?

    //MARK: - ViewControllers Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.title = objIimage?.title
//        indicator.startAnimating()
//        imgView.sd_setImage(with: URL(string: objIimage?.imageURL ?? "")) { img, error, type, url in
//            self.imgView.image = img
//            self.indicator.stopAnimating()
//        }
//        self.lblTitle.text = objIimage?.title
//        self.lblDesc.text = objIimage?.description
    }
}
