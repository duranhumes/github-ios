//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/14/21.
//

import UIKit

class FavoritesListVC: UIViewController {
    let tableView = UITableView()

    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        getFavorites()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        getFavorites()
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground

        title = "Favorites"

        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureTableView() {
        view.addSubview(tableView)

        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }

    func getFavorites() {
        PersistenceManager.get { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(favorites):
                if favorites.isEmpty {
                    self.showEmptyStateView(with: "No favorites?\n Add one on the followers tab", in: self.view)

                    return
                }

                self.favorites = favorites
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.bringSubviewToFront(self.tableView)
                }
            case let .failure(error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension FavoritesListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell

        let favorite = favorites[indexPath.row]

        cell.set(favorite: favorite)

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]

        let destinationVC = FollowerListVC()

        destinationVC.userName = favorite.login
        destinationVC.title = favorite.login

        navigationController?.pushViewController(destinationVC, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let favorite = favorites[indexPath.row]

        favorites.remove(at: indexPath.row)

        tableView.deleteRows(at: [indexPath], with: .left)

        PersistenceManager.update(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }

            guard let error = error else { return }

            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
