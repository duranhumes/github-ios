//
//  GFFollowersItemVC.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/25/21.
//

import UIKit

protocol GFFollowersItemVCDelegate: class {
    func didTapGetFollowers(for user: User)
}

class GFFollowersItemVC: GFItemInfoVC {
    weak var delegate: GFFollowersItemVCDelegate!

    init(user: User, delegate: GFFollowersItemVCDelegate) {
        super.init(user: user)

        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureItems()
    }

    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)

        actionButton.set(backgroundColor: .systemGreen, title: "Github followers")
    }

    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
