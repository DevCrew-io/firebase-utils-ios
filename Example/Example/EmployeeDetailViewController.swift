//
//  EmployeeDetailViewController.swift
//  Example
//
//  Created by Maaz Rafique on 04/07/2023.
//

import UIKit

class EmployeeDetailViewController: UIViewController {
    @IBOutlet weak var managerLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var deptLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var fsEmployee: FSEmployee?
    var dbEmployee: DBEmployee?
    var empId: String?
    var vm = EmployeeDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        AppController.shared.operationType == .firestore ? getFSEmployee() : getDBEmployee()
    }
    
    private func getFSEmployee() {
        guard let empId = empId else { return }
        vm.fetchFSEmployeeDetails(id: empId) {[weak self] result in
            switch result {
            case .success(let employee):
                self?.fsEmployee = employee
                self?.populateFSEmployee()
            case .failure(let error):
                AppUtils.showAlert(message: error.localizedDescription, controller: self)
            }
        }
    }
    
    private func getDBEmployee() {
        guard let empId = empId else { return }
        vm.fetchDBEmployeeDetails(id: empId) {[weak self] result in
            switch result {
            case .success(let employee):
                self?.dbEmployee = employee
                self?.populateDBEmployee()
            case .failure(let error):
                AppUtils.showAlert(message: error.localizedDescription, controller: self)
            }
            
        }
    }
    
    private func populateFSEmployee() {
        nameLabel.text = (fsEmployee?.name == "" || fsEmployee?.name == nil) ? "N/A" : fsEmployee?.name
        title = (fsEmployee?.name == "" || fsEmployee?.name == nil) ? "Detail" : fsEmployee?.name
        jobTitleLabel.text = (fsEmployee?.jobTitle == "" || fsEmployee?.jobTitle == nil) ? "N/A" : fsEmployee?.jobTitle
        deptLabel.text = (fsEmployee?.department == "" || fsEmployee?.department == nil) ? "N/A" : fsEmployee?.department
        managerLabel.text = (fsEmployee?.manger == "" || fsEmployee?.manger == nil) ? "N/A" : fsEmployee?.manger
        emailLabel.text = (fsEmployee?.email == "" || fsEmployee?.email == nil) ? "N/A" : fsEmployee?.email
        phoneLabel.text = (fsEmployee?.phone == "" || fsEmployee?.phone == nil) ? "N/A" : fsEmployee?.phone
        aboutLabel.text = (fsEmployee?.about == "" || fsEmployee?.about == nil) ? "N/A" : fsEmployee?.about
        address.text = (fsEmployee?.address == "" || fsEmployee?.address == nil) ? "N/A" : fsEmployee?.address
        profileImageView.layer.cornerRadius = 35.0
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        if let imagePath = fsEmployee?.picUrl, !imagePath.isEmpty, let url = URL(string: imagePath) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
        } else {
            profileImageView.image = UIImage(systemName: "person.crop.circle")
        }
    }
    
    private func populateDBEmployee() {
        nameLabel.text = (dbEmployee?.name == "" || dbEmployee?.name == nil) ? "N/A" : fsEmployee?.name
        title = (dbEmployee?.name == "" || dbEmployee?.name == nil) ? "Detail" : fsEmployee?.name
        jobTitleLabel.text = (dbEmployee?.jobTitle == "" || dbEmployee?.jobTitle == nil) ? "N/A" : dbEmployee?.jobTitle
        deptLabel.text = (dbEmployee?.department == "" || dbEmployee?.department == nil) ? "N/A" : dbEmployee?.department
        managerLabel.text = (dbEmployee?.manger == "" || dbEmployee?.manger == nil) ? "N/A" : dbEmployee?.manger
        emailLabel.text = (dbEmployee?.email == "" || dbEmployee?.email == nil) ? "N/A" : dbEmployee?.email
        phoneLabel.text = (dbEmployee?.phone == "" || dbEmployee?.phone == nil) ? "N/A" : dbEmployee?.phone
        aboutLabel.text = (dbEmployee?.about == "" || dbEmployee?.about == nil) ? "N/A" : dbEmployee?.about
        address.text = (dbEmployee?.address == "" || dbEmployee?.address == nil) ? "N/A" : dbEmployee?.address
        profileImageView.layer.cornerRadius = 35.0
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        if let imagePath = dbEmployee?.picUrl, !imagePath.isEmpty, let url = URL(string: imagePath) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
        } else {
            profileImageView.image = UIImage(systemName: "person.crop.circle")
        }
    }
    
    @objc func editButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let setEmployeeViewController = storyboard.instantiateViewController(withIdentifier: "SetEmployeeViewController") as? SetEmployeeViewController {
            if AppController.shared.operationType == .firestore {
                setEmployeeViewController.fsEmployee = fsEmployee
            } else {
                setEmployeeViewController.dbEmployee = dbEmployee
            }
            navigationController?.pushViewController(setEmployeeViewController, animated: true)
        }
    }

}
