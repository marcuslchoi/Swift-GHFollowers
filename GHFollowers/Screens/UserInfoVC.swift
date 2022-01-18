//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/17/22.
//

import UIKit

class UserInfoVC: UIViewController {
    
    //headerView is the container view for our user info header view controller
    let headerView = UIView()
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        layoutUI()
        getUserInfo()
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(username: username) { result in
            switch result {
                
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childVC: GHUserInfoHeaderVC(user: user), to: self.headerView)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func dismissVC()
    {
        dismiss(animated: true)
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    func layoutUI() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
}
