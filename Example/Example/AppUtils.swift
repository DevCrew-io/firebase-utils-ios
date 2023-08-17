//
//  AppUtils.swift
//  Example
//
//  Copyright © 2023 DevCrew I/O.
//

import UIKit

class AppUtils {
    static func showAlert(message: String, controller: UIViewController?) {
        let alert = UIAlertController()
        alert.title = "Alert!"
        alert.message = message
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        controller?.present(alert, animated: true)
    }
}
