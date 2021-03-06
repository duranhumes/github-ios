//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/14/21.
//

import UIKit

class GFAvatarImageView: UIImageView {
    let cache = NetworkManager.shared.cache
    let placeholderImage = Images.avatarPlaceholder

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 10

        clipsToBounds = true

        image = placeholderImage

        translatesAutoresizingMaskIntoConstraints = false
    }
}
