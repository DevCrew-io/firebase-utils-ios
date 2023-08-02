//
//  ViewController.swift
//  Example
//
//  Created by Maaz Rafique on 03/07/2023.
//

import UIKit
import FirebaseServicesManager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func operationButtonTapped(_ sender: UIButton) {
        switch (sender.tag) {
        case TappedButton.database.rawValue:
            AppController.shared.operationType = .database
            AppController.shared.reactiveType = .observable
        case TappedButton.reactiveDatabase.rawValue:
            AppController.shared.operationType = .firestore
            AppController.shared.reactiveType = .nonObservable
        case TappedButton.firestore.rawValue:
            AppController.shared.operationType = .firestore
            AppController.shared.reactiveType = .nonObservable
        case TappedButton.reactiveFirestore.rawValue:
            AppController.shared.operationType = .firestore
            AppController.shared.reactiveType = .nonObservable
        default:
            break
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let listViewController = storyboard.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController else {return}

        navigationController?.pushViewController(listViewController, animated: true)
         
    }
    
}

