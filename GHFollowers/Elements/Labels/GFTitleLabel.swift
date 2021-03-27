//
//  GFTitleLabel.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/14/21.
//

import UIKit

class GFTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(textAlign: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)

        textAlignment = textAlign
        font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }

    private func configure() {
        textColor = .label

        adjustsFontSizeToFitWidth = true

        minimumScaleFactor = 0.90

        lineBreakMode = .byTruncatingTail

        translatesAutoresizingMaskIntoConstraints = false
    }
}
