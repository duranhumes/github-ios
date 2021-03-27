//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/14/21.
//

import UIKit

class FollowerListVC: GFDataLoadingVC {
    enum Section {
        case main
    }

    var userName: String!
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false

    init(userName: String) {
        super.init(nibName: nil, bundle: nil)

        self.userName = userName

        title = userName
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureCollectionView()

        getFollowers(userName: userName, page: page)

        configureDataSource()

        configureSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureViewController() {
        navigationController?.navigationBar.prefersLargeTitles = true

        view.backgroundColor = .systemBackground

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))

        navigationItem.rightBarButtonItem = addButton
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))

        view.addSubview(collectionView)

        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }

    func configureSearchController() {
        let searchController = UISearchController()

        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"

        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
    }

    func getFollowers(userName: String, page: Int) {
        showLoadingView()

        NetworkManager.shared.getFollowers(for: userName, page: page) { [weak self] result in
            guard let self = self else { return }

            self.dismissLoadingView()

            switch result {
            case let .success(followers):
                if followers.count < 100 {
                    self.hasMoreFollowers = false
                }

                self.followers.append(contentsOf: followers)

                if self.followers.isEmpty {
                    DispatchQueue.main.async {
                        let message = "This user doesn't have any followers 😔"

                        self.showEmptyStateView(with: message, in: self.view)
                    }

                    return
                }

                self.updateData(on: self.followers)

            case let .failure(error):
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "Ok")

                return
            }
        }
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in

                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell

                cell.set(follower: follower)

                return cell
            }
        )
    }

    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)

        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    @objc func addButtonTapped() {
        showLoadingView()

        isLoadingMoreFollowers = true

        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
            guard let self = self else { return }

            self.dismissLoadingView()

            switch result {
            case let .success(user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)

                PersistenceManager.update(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else { return }

                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Success", message: "You have succesfully favorited this user 🎉", buttonTitle: "Horray")

                        return
                    }

                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }
            case let .failure(error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }

            self.isLoadingMoreFollowers = false
        }
    }
}

extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate _: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }

            page += 1

            getFollowers(userName: userName, page: page)
        }
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers

        let follower = activeArray[indexPath.item]

        let destinationVC = UserInfoVC()

        destinationVC.userName = follower.login
        destinationVC.delegate = self

        let navigationController = UINavigationController(rootViewController: destinationVC)

        present(navigationController, animated: true)
    }
}

extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()

            updateData(on: followers)

            isSearching = false

            return
        }

        isSearching = true

        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }

        updateData(on: filteredFollowers)
    }
}

extension FollowerListVC: UserInfoVCDelegate {
    func didRequestFollowers(for userName: String) {
        self.userName = userName

        title = userName

        page = 1

        followers.removeAll()
        filteredFollowers.removeAll()

        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)

        getFollowers(userName: userName, page: page)
    }
}
