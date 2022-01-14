//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/13/22.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImgView = UIImageView()
    let searchTxtField = GHTextField()
    var isUsernameEntered: Bool {
        return !searchTxtField.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addLogoImgView()
        addSearchTextField()
        createDismissKeyboardTapGesture()
        searchTxtField.delegate = self
    }
    
    func pushFollowerListVC()
    {
        if isUsernameEntered
        {
            let followerListVC = FollowerListVC()
            let username = searchTxtField.text!
            followerListVC.searchUsername = username
            followerListVC.title = username
            navigationController?.pushViewController(followerListVC, animated: true)
        }
        else
        {
            print("Please enter a username")
        }
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func addLogoImgView()
    {
        view.addSubview(logoImgView)
        logoImgView.translatesAutoresizingMaskIntoConstraints = false
        logoImgView.image = UIImage(named: "gh-logo")!
        
        let constraints = [
            logoImgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImgView.heightAnchor.constraint(equalToConstant: 200),
            logoImgView.widthAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func addSearchTextField()
    {
        view.addSubview(searchTxtField)
        searchTxtField.placeholder = "Enter Username"
        let constraints = [
            searchTxtField.topAnchor.constraint(equalTo: logoImgView.bottomAnchor, constant: 80),
            searchTxtField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTxtField.heightAnchor.constraint(equalToConstant: 50),
            searchTxtField.widthAnchor.constraint(equalToConstant: 300)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
