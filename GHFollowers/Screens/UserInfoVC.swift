//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/17/22.
//

import UIKit

class UserInfoVC: UIViewController {
    
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        getUserInfo()
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(username: username) { result in
            switch result {
                
            case .success(let user):
                print(user)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func dismissVC()
    {
        dismiss(animated: true)
    }
}
