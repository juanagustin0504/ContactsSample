//
//  ViewController.swift
//  ContactTesting
//
//  Created by Webcash on 2021/07/06.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController {

    // 선택된 연락처 정보를 가질 객체입니다
    var selectedContact: CNContact?
    var selectedContacts: [CNContact]?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    
}

//MARK: - Button Action
extension ViewController {
    @IBAction func clickShowContactsPickerController(_ sender: UIButton) {
        // 연락처 선택 뷰 컨트롤러를 생성하여 화면에 보여줍니다
        let contactsPicker: CNContactPickerViewController = CNContactPickerViewController()
        contactsPicker.delegate = self
        self.present(contactsPicker, animated: true, completion: nil)
    }
    
}

extension ViewController: CNContactPickerDelegate {
    @objc func dismissModalViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 연락처 단일 선택
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
//        self.selectedContact = contact
//        self.tableView.reloadData()
//    }
    
    // 연락처 다중 선택
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        if contacts.count == 1 {
            selectedContact = contacts.first
        } else {
            self.selectedContacts = contacts
        }
        self.tableView.reloadData()
    }
    
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
//        self.selectedContact = contact
//        self.tableView.reloadData()
//    }
    
//    func contactPicker(_ picker: CNContactPickerViewController, didSelectContactProperties contactProperties: [CNContactProperty]) {
//        if contactProperties.count == 1 {
//            selectedContact = contactProperties.first
//        } else {
//            self.selectedContacts = contactProperties
//        }
//        self.tableView.reloadData()
//    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedContact != nil {
            return 1
        } else if let contacts = self.selectedContacts {
            return contacts.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else {
            return UITableViewCell()
        }
        
        // 연락처에서 fullName을 가져와서 화면 상으로 보여줍니다
        if let contact = self.selectedContact {
            let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
            cell.configure(fullName: fullName)
        } else if let contacts = self.selectedContacts {
            let fullName = CNContactFormatter.string(from: contacts[indexPath.row], style: .fullName) ?? ""
            cell.configure(fullName: fullName)
        } else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택하여 가져온 연락처 정보가 있다면 연락처 정보를 보여줍니다
        if let contact = self.selectedContact {
            let contactVC: CNContactViewController = CNContactViewController(for: contact)
            let navigation = UINavigationController(rootViewController: contactVC)
            let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissModalViewController))
            contactVC.navigationItem.rightBarButtonItem = closeButton
            self.present(navigation, animated: true, completion: nil)
        } else if let contacts = self.selectedContacts {
            let contactVC: CNContactViewController = CNContactViewController(for: contacts[indexPath.row])
            let navigation = UINavigationController(rootViewController: contactVC)
            let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissModalViewController))
            contactVC.navigationItem.rightBarButtonItem = closeButton
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
}

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var nameLb: UILabel!
    
    func configure(fullName: String) {
        self.nameLb.text = fullName
    }
}
