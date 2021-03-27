//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/25/21.
//

import UIKit

protocol GFRepoItemVCDelegate: class {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemVC: GFItemInfoVC {
    weak var delegate: GFRepoItemVCDelegate!

    init(user: User, delegate: GFRepoItemVCDelegate) {
        super.init(user: user)

        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureItems()
    }

    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)

        actionButton.set(backgroundColor: .systemPurple, title: "Github profile")
    }

    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}
