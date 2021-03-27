//
//  GFEmptyStateView.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/23/21.
//

import UIKit

class GFEmptyStateView: UIView {
    let messageLabel = GFTitleLabel(textAlign: .center, fontSize: 28)
    let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(message: String) {
        self.init(frame: .zero)

        messageLabel.text = message
    }

    private func configure() {
        configureLogoImageView()

        configureMessageLabel()
    }

    private func configureMessageLabel() {
        addSubview(messageLabel)

        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel

        let labelCenterYConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -50 : -120

        let messageLabelCenterYConstraint = messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: labelCenterYConstant)

        messageLabelCenterYConstraint.isActive = true

        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
        ])
    }

    private func configureLogoImageView() {
        addSubview(logoImageView)

        logoImageView.image = Images.emptyStateLogo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        let logoBottomConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 100 : 40

        let logoImageViewBottomConstraint = logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: logoBottomConstant)

        logoImageViewBottomConstraint.isActive = true

        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
        ])
    }
}
