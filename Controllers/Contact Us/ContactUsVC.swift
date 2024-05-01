//
//  ContactUsVC.swift
//  My Hotels
//
//  Created by My Hotels on 09/12/22.
//

import UIKit

class ContactUsVC: UIViewController {

    //MARK: - Outlets -
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPinCode: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    //MARK: - variables -
    var arrayTextFields = [UITextField]()
    
    //MARK: - ViweController Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Contact Us", comment: "")
        let appearance = UINavigationBarAppearance()
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        btnSubmit.layer.cornerRadius = 8.0
        arrayTextFields = [txtFirstName, txtLastName, txtEmail, txtPhone, txtPinCode]
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(self.doneWithNumberPad))]
        
        numberToolbar.sizeToFit()
        
        for textField in arrayTextFields {
            textField.delegate = self
            textField.inputAccessoryView = numberToolbar
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
       //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @objc func doneWithNumberPad() {
        view.endEditing(true)
    }
    
    
    //MARK: - IBActions -
    @IBAction func actionSubmitClicked(_ sender: Any) {
        for textField in arrayTextFields {
            if textField.text?.isEmpty == true || textField.text == "" {
                let alert = UIAlertController(title: NSLocalizedString("My Hotel", comment: ""), message: NSLocalizedString("Please fill up all the fields.", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
                self.present(alert, animated: true)
                return
            }
        }
        
        let alert = UIAlertController(title: NSLocalizedString("My Hotel", comment: ""), message: NSLocalizedString("Thank you for the contacting us. You will receive email from our side in short time.", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
            self.clearAllTextfields()
        }))
        self.present(alert, animated: true)
    }
    
    //Clear all the textfields
    func clearAllTextfields(){
        for textField in arrayTextFields {
            textField.text = ""
        }
    }
}

//MARK: - UITextfield Delegate -
extension ContactUsVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        } else if textField == txtLastName {
            txtEmail.becomeFirstResponder()
        } else if textField == txtEmail {
            txtPhone.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

}
