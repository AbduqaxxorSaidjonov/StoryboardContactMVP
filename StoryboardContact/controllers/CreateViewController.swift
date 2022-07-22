//
//  CreateViewController.swift
//  StoryboardContact
//
//  Created by Abduqaxxor on 19/7/22.
//

import UIKit

class CreateViewController: BaseViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBAction func addButton(_ sender: Any) {
        apiPostCreate()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    @IBOutlet weak var button1: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }

    func initViews(){
        initNavigation()
        button1.layer.cornerRadius = 15
    }
    
    func initNavigation(){
        title = "Add Contact"
        let back = UIImage(systemName: "chevron.backward")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: back, style: .plain, target: self, action: #selector(leftTapped))
    }
    
    @objc func leftTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    func apiPostCreate(){
        showProgress()
        AFHttp.post(url: AFHttp.API_CONTACT_CREATE, params: AFHttp.paramsContactCreate(contact: Contact(name: nameTextField.text!, phone: phoneTextField.text!)), handler: {response in
            self.hideProgress()
            switch response.result{
            case .success:
                print(response.result)
                self.navigationController?.popViewController(animated: true)
            case let .failure(error):
                print(error)
            }
        })
    }
}
