//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/13/22.
//

import UIKit

class SearchVC: UIViewController {
    
    var logoImgView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addLogoImgView()
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
}
