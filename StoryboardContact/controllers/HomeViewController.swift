//
//  HomeViewController.swift
//  StoryboardContact
//
//  Created by Abduqaxxor on 19/7/22.
//

import UIKit

class HomeViewController: BaseViewController, UITableViewDelegate,  UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    var items : Array<Contact> = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }


    func initViews(){
        tableView.dataSource = self
        tableView.delegate = self
        initNavigation()
        apiContactList()
        refreshView()
    }

    func initNavigation(){
        let refresh = UIImage(named: "ic_refresh")
        let add = UIImage(named: "ic_add")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: refresh, style: .plain, target: self, action: #selector(leftTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: add, style: .plain, target: self, action: #selector(rightTapped))
        title = "Storyboard Contact"
    }
    
    func callCreateViewController(){
    let vc = CreateViewController(nibName: "CreateViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func callEditViewController(contactId: String){
        let vc = EditViewController(nibName: "EditViewController", bundle: nil)
        vc.ContactId = contactId
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func apiContactList(){
        showProgress()
        AFHttp.get(url: AFHttp.API_CONTACT_LIST, params: AFHttp.paramsEmpty(), handler: {response in
            self.hideProgress()
            switch response.result{
            case .success:
                let contacts = try! JSONDecoder().decode([Contact].self, from: response.data!)
                self.refreshTableView(contacts: contacts)
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func apiContactDelete(contact: Contact){
        showProgress()
        AFHttp.del(url: AFHttp.API_CONTACT_DELETE + contact.id!, params: AFHttp.paramsEmpty(), handler: { response in
            self.hideProgress()
            switch response.result{
            case .success:
                print(response.result)
                self.apiContactList()
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func refreshView(){
        NotificationCenter.default.addObserver(self, selector: #selector(doThisWhenNotifyLoad(notification: )), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(doThisWhenNotifyEdit(notification: )), name: NSNotification.Name(rawValue: "edit"), object: nil)
    }

    
    // MARK: - Action
    
    @objc func leftTapped(){
        apiContactList()
    }
    
    @objc func rightTapped(){
        callCreateViewController()
    }
    
    @objc func doThisWhenNotifyLoad(notification : NSNotification) {
            //update tableview
        apiContactList()
    }
    
    @objc func doThisWhenNotifyEdit(notification : NSNotification) {
            //update tableview
        apiContactList()
    }
    
    // MARK: - Table View
    
    func refreshTableView(contacts: [Contact]){
        self.items = contacts
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let item = items[indexPath.row]
        
        let cell = Bundle.main.loadNibNamed("ContactTableViewCell", owner: self,options: nil)?.first as! ContactTableViewCell
        cell.nameLabel.text = item.name
        cell.phoneLabel.text = item.phone
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [makeCompleteContextualAction(forRowAt: indexPath, contact: items[indexPath.row])
        ])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [makeDeleteContextualAction(forRowAt: indexPath, contact: items[indexPath.row])
        ])
    }
    
    func makeDeleteContextualAction(forRowAt indexPath: IndexPath, contact: Contact) -> UIContextualAction{
        return UIContextualAction(style: .destructive, title: "Delete"){ (action, swipeButtonView, completion) in
            print("Delete Here")
            completion(true)
            self.apiContactDelete(contact: contact)
        }
    }
    
    func makeCompleteContextualAction(forRowAt indexPath: IndexPath, contact: Contact) -> UIContextualAction{
        return UIContextualAction(style: .normal, title: "Edit"){ (action, swipeButtonView, completion) in
            print("Complete Here")
            completion(true)
            self.callEditViewController(contactId: contact.id!)
        }
    }
}
