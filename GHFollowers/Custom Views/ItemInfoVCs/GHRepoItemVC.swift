//
//  GHRepoItemInfoVC.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/18/22.
//

import UIKit

class GHRepoItemVC: GHItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    
//    override func actionButtonTapped() {
//        delegate.didTapGitHubProfile(for: user)
//    }

}
