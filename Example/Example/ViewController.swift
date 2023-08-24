//
//  ViewController.swift
//  Example
//
//  Copyright © 2023 DevCrew I/O.
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
        guard let tappedButton = TappedButton(rawValue: sender.tag) else { return }
        
        let appController = AppController.shared
        var operationType: OperationType = .database
        var reactiveType: ReactiveType = .observable
        
        
        
        switch tappedButton {
        case .reactiveDatabase, .reactiveFirestore:
            reactiveType = .nonObservable
        default:
            break
        }
        
        switch tappedButton {
        case .reactiveDatabase, .database:
            operationType = .database
        case .reactiveFirestore, .firestore:
            operationType = .firestore
        }
        
        appController.operationType = operationType
        appController.reactiveType = reactiveType
        
        if let listViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ListViewController") as? ListViewController {
            navigationController?.pushViewController(listViewController, animated: true)
        }
        
    }
    
}

