//
//  UIVC+Ext.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/14/21.
//

import SafariServices
import UIKit

extension UIViewController {
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)

            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve

            self.present(alertVC, animated: true)
        }
    }

    func presentSafariVCWith(with url: URL) {
        let safariVC = SFSafariViewController(url: url)

        safariVC.preferredControlTintColor = .systemGreen

        present(safariVC, animated: true)
    }
}
