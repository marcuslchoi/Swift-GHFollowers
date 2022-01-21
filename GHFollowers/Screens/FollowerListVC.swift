//
//  FollowerListVCViewController.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/14/22.
//

//get followers (login and avatar url), then update data creates the snapshot of cells to display, then dequeue reusable cells downloads the images (current understanding)

import UIKit

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class FollowerListVC: UIViewController {

    //sections of collection view
    enum Section {
        case main
    }
    
    var searchUsername: String!
    var followerCollectionView: UICollectionView!
    //section and follower must be hashable (enum is hashable by default)
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var allFollowers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var currPage = 1
    var hasMoreFollowers = true
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        addFollowerCollectionView()
        configureDataSource()
        configureSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFollowers()
    }
    
    func configureViewController()
    {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    //get the user's user info so we an turn it into a Follower object and download their avatar
    @objc func addButtonTapped() {
        NetworkManager.shared.getUserInfo(username: self.searchUsername) { result in
            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: PersistenceActionType.add) { error in
                    guard let error = error else {
                        print("successfully added \(user.login) to favorites")
                        return
                    }
                    print("failed to update favorites: \(error.rawValue)")
                }
            case .failure(let error):
                print("failed to get user info: \(error.rawValue)")
            }
        }
    }
    
    func getFollowers()
    {
        guard hasMoreFollowers else {
            print("user has no more followers")
            return
        }
        //network manager and self have strong refs to each other, so use weak self
        NetworkManager.shared.getFollowers(username: searchUsername, page: currPage) { [weak self] result in
            guard let self = self else { return }
            switch result
            {
                case .success(let currPageFollowers):
                    print(currPageFollowers)
                    self.allFollowers.append(contentsOf: currPageFollowers)
                    if currPageFollowers.count == 100 {
                        self.currPage += 1
                    } else {
                        self.hasMoreFollowers = false
                    }
                //call update data once we get followers
                self.updateData(followers: self.allFollowers)
                case .failure(let ghError):
                    print(ghError.rawValue)
            }
        }
    }

    func addFollowerCollectionView()
    {
        followerCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(followerCollectionView)
        //followerCollectionView.backgroundColor = .systemPink
        followerCollectionView.register(GHFollowerCell.self, forCellWithReuseIdentifier: GHFollowerCell.reuseId)
        followerCollectionView.delegate = self
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "search for a username"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: followerCollectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GHFollowerCell.reuseId, for: indexPath) as! GHFollowerCell
            //downloads the image
            cell.setFollowerNameAndImage(follower: follower)
            return cell
        })
    }
    
    //create a new snapshot to display the followers
    func updateData(followers: [Follower])
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        print(offsetY)
        if offsetY > contentHeight - screenHeight
        {
            print("at bottom of page")
            getFollowers()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeFollowersArr = isSearching ? filteredFollowers : allFollowers
        let selectedFollower = activeFollowersArr[indexPath.item]
        let destVC = UserInfoVC()
        //if get followers tapped on the user info page, follower list vc will know
        destVC.delegate = self
        destVC.username = selectedFollower.login
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text, !searchString.isEmpty else { return }
        filteredFollowers = allFollowers.filter { $0.login.lowercased().contains(searchString.lowercased()) }
        updateData(followers: filteredFollowers)
        isSearching = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(followers: allFollowers)
        isSearching = false
    }
}

extension FollowerListVC: FollowerListVCDelegate {
    func didRequestFollowers(for username: String) {
        self.searchUsername = username
        title = username
        currPage = 1
        hasMoreFollowers = true
        isSearching = false
        allFollowers.removeAll()
        filteredFollowers.removeAll()
        //scroll to top
        followerCollectionView.setContentOffset(.zero, animated: true)
        getFollowers()
    }
    
    
}
