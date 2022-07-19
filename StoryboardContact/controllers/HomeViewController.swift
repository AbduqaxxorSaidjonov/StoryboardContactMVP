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
        items.append(Contact(name: "Abduqahhor", phone: "+998333222580"))
        items.append(Contact(name: "Abdulaziz", phone: "+998983072349"))
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
    
    func callEditViewController(){
        let vc = EditViewController(nibName: "EditViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Action
    
    @objc func leftTapped(){
        
    }
    
    @objc func rightTapped(){
        callCreateViewController()
    }
    
    // MARK: - Table View
    
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
        return UISwipeActionsConfiguration(actions: [makeCompleteContextualAction(forRowAt: indexPath, post: items[indexPath.row])
        ])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [makeDeleteContextualAction(forRowAt: indexPath, post: items[indexPath.row])
        ])
    }
    
    func makeDeleteContextualAction(forRowAt indexPath: IndexPath, post: Contact) -> UIContextualAction{
        return UIContextualAction(style: .destructive, title: "Delete"){ (action, swipeButtonView, completion) in
            print("Delete Here")
            completion(true)
        }
    }
    
    func makeCompleteContextualAction(forRowAt indexPath: IndexPath, post: Contact) -> UIContextualAction{
        return UIContextualAction(style: .normal, title: "Edit"){ (action, swipeButtonView, completion) in
            print("Complete Here")
            completion(true)
            self.callEditViewController()
        }
    }
}
