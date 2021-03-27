//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/26/21.
//

import UIKit

extension UITableView {
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }

    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
