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
    var employee: Employee?
    var empId: String?
    var vm = EmployeeDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        getEmployee()
    }
    
    private func getEmployee() {
        guard let empId = empId else { return }
        vm.fetchEmployeeDetails(empId: empId) {[weak self] result in
            switch result {
            case .success(let employee):
                self?.employee = employee
                self?.populateEmployee()
            case .failure(let error):
                self?.present(UIAlertController(title: "Alert!", message: error.localizedDescription, preferredStyle: .alert), animated: true)
            }
            
        }
    }
    
    private func populateEmployee() {
        nameLabel.text = (employee?.name == "" || employee?.name == nil) ? "N/A" : employee?.name
        title = (employee?.name == "" || employee?.name == nil) ? "Detail" : employee?.name
        jobTitleLabel.text = (employee?.jobTitle == "" || employee?.jobTitle == nil) ? "N/A" : employee?.jobTitle
        deptLabel.text = (employee?.department == "" || employee?.department == nil) ? "N/A" : employee?.department
        managerLabel.text = (employee?.manger == "" || employee?.manger == nil) ? "N/A" : employee?.manger
        emailLabel.text = (employee?.email == "" || employee?.email == nil) ? "N/A" : employee?.email
        phoneLabel.text = (employee?.phone == "" || employee?.phone == nil) ? "N/A" : employee?.phone
        aboutLabel.text = (employee?.about == "" || employee?.about == nil) ? "N/A" : employee?.about
        address.text = (employee?.address == "" || employee?.address == nil) ? "N/A" : employee?.address
        profileImageView.layer.cornerRadius = 35.0
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        if let imagePath = employee?.picUrl, !imagePath.isEmpty, let url = URL(string: imagePath) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
        } else {
            profileImageView.image = UIImage(systemName: "person.crop.circle")
        }
    }
    
    @objc func editButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let setEmployeeViewController = storyboard.instantiateViewController(withIdentifier: "SetEmployeeViewController") as? SetEmployeeViewController {
            setEmployeeViewController.employee = employee
            navigationController?.pushViewController(setEmployeeViewController, animated: true)
        }
    }

}
