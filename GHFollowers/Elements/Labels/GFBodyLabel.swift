//
//  GFBodyLabel.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/14/21.
//

import UIKit

class GFBodyLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(textAlign: NSTextAlignment) {
        super.init(frame: .zero)

        textAlignment = textAlign

        configure()
    }

    private func configure() {
        textColor = .secondaryLabel

        adjustsFontSizeToFitWidth = true

        minimumScaleFactor = 0.75

        lineBreakMode = .byWordWrapping

        translatesAutoresizingMaskIntoConstraints = false

        font = UIFont.preferredFont(forTextStyle: .body)
    }
}
