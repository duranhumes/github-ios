//
//  FavoriteCell.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/25/21.
//

import UIKit

class FavoriteCell: UITableViewCell {
    static let reuseID = "FavoriteCell"

    let avatarImageView = GFAvatarImageView(frame: .zero)
    let userNameLabel = GFTitleLabel(textAlign: .left, fontSize: 26)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(favorite: Follower) {
        userNameLabel.text = favorite.login

        NetworkManager.shared.downloadImage(from: favorite.avatarUrl) { [weak self] image in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
    }

    private func configure() {
        addSubviews(avatarImageView, userNameLabel)

        accessoryType = .disclosureIndicator

        let padding: CGFloat = 12

        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),

            userNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
