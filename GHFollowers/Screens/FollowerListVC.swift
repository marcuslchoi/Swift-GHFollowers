//
//  FollowerListVCViewController.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/14/22.
//

import UIKit

class FollowerListVC: UIViewController {

    //sections of collection view
    enum Section {
        case main
    }
    
    var searchUsername: String!
    var followerCollectionView: UICollectionView!
    //section and follower must be hashable (enum is hashable by default)
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var followers: [Follower] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        addFollowerCollectionView()
        configureDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFollowers()
    }
    
    func getFollowers()
    {
        NetworkManager.shared.getFollowers(username: searchUsername, page: 1) { result in
            
            switch result
            {
                case .success(let followers):
                    print(followers)
                    self.followers = followers
                    //call update data once we get followers
                    self.updateData()
                case .failure(let ghError):
                    print(ghError.rawValue)
            }
        }
    }

    func addFollowerCollectionView()
    {
        followerCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        view.addSubview(followerCollectionView)
        //followerCollectionView.backgroundColor = .systemPink
        followerCollectionView.register(GHFollowerCell.self, forCellWithReuseIdentifier: GHFollowerCell.reuseId)
    }
    
    func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout
    {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minItemSpacing: CGFloat = 10
        //the width of the cells combined
        let availableWidth = width - (2*padding) - (2*minItemSpacing)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        //add a little to the height since it has image and label
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        return flowLayout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: followerCollectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GHFollowerCell.reuseId, for: indexPath) as! GHFollowerCell
            cell.setFollower(follower: follower)
            return cell
        })
    }
    
    func updateData()
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
    }
}
