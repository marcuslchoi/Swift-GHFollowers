//
//  FollowerListVCViewController.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/14/22.
//

import UIKit

class FollowerListVC: UIViewController {

    var searchUsername = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NetworkManager.shared.getFollowers(username: searchUsername, page: 1) { followers, errorDesc in
            print(followers)
        }
    }

}
