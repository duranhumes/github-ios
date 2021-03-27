//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/23/21.
//

import UIKit

protocol UserInfoVCDelegate: class {
    func didRequestFollowers(for userName: String)
}

class UserInfoVC: UIViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlign: .center)

    var itemViews: [UIView] = []
    var userName: String!
    weak var delegate: UserInfoVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
        configureScrollView()
        layoutUI()
        getUserInfo()
    }

    func configureVC() {
        view.backgroundColor = .systemBackground

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))

        navigationItem.rightBarButtonItem = doneButton
    }

    func configureScrollView() {
        view.addSubview(scrollView)

        scrollView.addSubview(contentView)
        scrollView.pinToSuperViewEdges(of: view)

        contentView.pinToSuperViewEdges(of: scrollView)

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600),
        ])
    }

    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }
            case let .failure(error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    func configureUIElements(with user: User) {
        add(childVC: GFUserInfoHeader(user: user), to: headerView)

        add(childVC: GFRepoItemVC(user: user, delegate: self), to: itemViewOne)

        add(childVC: GFFollowersItemVC(user: user, delegate: self), to: itemViewTwo)

        dateLabel.text = "Github since \(user.createdAt.convertToMonthYearFormat())"
    }

    func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]

        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        for itemView in itemViews {
            contentView.addSubview(itemView)

            itemView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),

            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)

        containerView.addSubview(childVC.view)

        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

extension UserInfoVC: GFRepoItemVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid url", message: "The url attached to this user is invalid", buttonTitle: "Ok")

            return
        }

        presentSafariVCWith(with: url)
    }
}

extension UserInfoVC: GFFollowersItemVCDelegate {
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers 😔", buttonTitle: "Ok")

            return
        }

        delegate.didRequestFollowers(for: user.login)

        dismissVC()
    }
}
