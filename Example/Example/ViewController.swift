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
        let dbEmployee = DBEmployee()
       // dbEmployee.name
        FirebaseServices.manager.database.add(dataObject: dbEmployee, completion: { result in
            print("fdsafds")
        })
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let listViewController = storyboard.instantiateViewController(withIdentifier: "ListViewController")
//
//        navigationController?.pushViewController(listViewController, animated: true)
         
    }
    
}

