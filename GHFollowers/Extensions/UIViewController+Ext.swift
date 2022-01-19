//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/18/22.
//

import Foundation
import UIKit
import SafariServices

extension UIViewController {
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
