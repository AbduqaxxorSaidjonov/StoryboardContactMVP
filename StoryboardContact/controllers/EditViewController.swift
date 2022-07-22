//
//  EditViewController.swift
//  StoryboardContact
//
//  Created by Abduqaxxor on 19/7/22.
//

import UIKit

class EditViewController: BaseViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var buttonEdit: UIButton!
    var ContactId: String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }

    func initViews(){
        buttonEdit.layer.cornerRadius = 15
        initNavigation()
        apiSingleContact(contactId: ContactId)
    }
    
    func initNavigation(){
        title = "Edit Contact"
        let back = UIImage(systemName: "chevron.backward")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: back, style: .plain, target: self, action: #selector(leftTapped))
    }
    
    @IBAction func editButton(_ sender: Any) {
        apiContactEdit(contactId: ContactId)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "edit"), object: nil)
    }
    
    @objc func leftTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    func apiSingleContact(contactId: String){
        showProgress()
        AFHttp.get(url: AFHttp.API_CONTACT_SINGLE + contactId, params: AFHttp.paramsEmpty(), handler: { response in
            self.hideProgress()
            switch response.result {
            case .success:
                print(response.result)
                let contact = try! JSONDecoder().decode(Contact.self, from: response.data!)
                self.nameTextField.text = contact.name
                self.phoneTextField.text = contact.phone
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func apiContactEdit(contactId: String){
        showProgress()
        AFHttp.put(url: AFHttp.API_CONTACT_UPDATE + contactId, params: AFHttp.paramsPostUpdate(contact: Contact(name: nameTextField.text!, phone: phoneTextField.text!)), handler: {response in
            switch response.result{
            case .success:
                print(response.result)
                self.dismiss(animated: true,completion: nil)
            case let .failure(error):
                print(error)
            }
        })
    }
}
