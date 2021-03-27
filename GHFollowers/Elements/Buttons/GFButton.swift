//
//  GFButton.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/14/21.
//

import UIKit

class GFButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)

        self.backgroundColor = backgroundColor

        setTitle(title, for: .normal)
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 10

        setTitleColor(.white, for: .normal)

        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    }

    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor

        setTitle(title, for: .normal)
    }
}
