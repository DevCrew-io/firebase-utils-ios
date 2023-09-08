//
//  EmployeesListViewController.swift
//  Example
//
//  Copyright © 2023 DevCrew I/O.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var vm = EmployeesListViewModel()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("printing")
        return AppController.shared.operationType == .firestore ? vm.employeesList.count : vm.dbEmployeesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("printing")
        if
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell") as? EmployeeTableViewCell
        {
            if AppController.shared.operationType == .firestore {
                let employee = vm.employeesList[indexPath.row]
                
                cell.nameLabel.text = employee.name
                cell.deptLabel.text = employee.department
                cell.jobTitleLabel.text = employee.jobTitle
                if let imagePath = employee.picUrl, !imagePath.isEmpty, let url = URL(string: imagePath) {
                    cell.profileImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
                } else {
                    cell.profileImageView.image = UIImage(systemName: "person.crop.circle")
                }
            } else {
                let employee = vm.dbEmployeesList[indexPath.row]
                
                cell.nameLabel.text = employee.name
                cell.deptLabel.text = employee.department
                cell.jobTitleLabel.text = employee.jobTitle
                if let imagePath = employee.picUrl, !imagePath.isEmpty, let url = URL(string: imagePath) {
                    cell.profileImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
                } else {
                    cell.profileImageView.image = UIImage(systemName: "person.crop.circle")
                }
            }
            
            
            return cell
        }
        return UITableViewCell()

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let empDetailViewController = storyboard.instantiateViewController(withIdentifier: "EmployeeDetailViewController") as? EmployeeDetailViewController else { return }
        empDetailViewController.empId = AppController.shared.operationType == .firestore ?  vm.employeesList[indexPath.row].docId : vm.dbEmployeesList[indexPath.row].nodeId
        navigationController?.pushViewController(empDetailViewController, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "EmployeeTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        vm.fetchAllEmployees {[weak self] error in
            guard let self = self else {return}
            if let error = error {
                AppUtils.showAlert(message: error.localizedDescription, controller: self)
            } else {
                self.tableView.reloadData()
            }
        }
        
        
        
    }
    @objc private func addTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let empDetailViewController = storyboard.instantiateViewController(withIdentifier: "SetEmployeeViewController") as? SetEmployeeViewController {
            navigationController?.pushViewController(empDetailViewController, animated: true)
        }
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        title = "Employees"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
    }
    

}
