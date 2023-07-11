//
//  SetEmployeeViewController.swift
//  Example
//
//  Created by Maaz Rafique on 05/07/2023.
//

import UIKit
import Kingfisher

class SetEmployeeViewController: UIViewController {

    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var mangarTF: UITextField!
    @IBOutlet weak var depTF: UITextField!
    @IBOutlet weak var jobTitleTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addressTV: UITextView!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var aboutTextView: UITextView!
    var isProfileImageChanged = false
    var vm = SetEmployeeViewModel()
    var employee: Employee?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " Add Employee"
        
        if let employee = employee {
            nameTF.text =  employee.name
            jobTitleTF.text = employee.jobTitle
            depTF.text = employee.department
            mangarTF.text = employee.manger
            emailTF.text = employee.email
            phoneTF.text = employee.phone
            aboutTextView.text = (employee.about?.isEmpty ?? false) ? "About" : employee.about
            addressTV.text = (employee.address?.isEmpty ?? false) ? "Address" : employee.address
            title = "Edit Employee"
            setButton.setTitle("Update", for: .normal)
            if let imagepath = employee.picUrl, !imagepath.isEmpty, let url = URL(string: imagepath) {
                profileImage.kf.setBackgroundImage(with: url, for: .normal, placeholder: UIImage(systemName: "person.crop.circle"))
            }

        }
        profileImage.layer.cornerRadius = 50.0
        profileImage.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    @IBAction func setButtonTapped(_ sender: UIButton) {
        var employee = Employee()
        employee.name = nameTF.text ?? ""
        employee.jobTitle = jobTitleTF.text ?? ""
        employee.department = depTF.text ?? ""
        employee.about = aboutTextView.text == "About" ? "" : aboutTextView.text ?? ""
        employee.address = addressTV.text == "Address" ? "" : addressTV.text
        employee.manger = mangarTF.text
        if let empId = self.employee?.docId, !empId.isEmpty {
            if isProfileImageChanged {
                if let imageData = self.profileImage.backgroundImage(for: .normal)?.pngData() {
                    if let picName = employee.picName, !picName.isEmpty {
                        vm.updateProfileImage(imageData: imageData, name: "\(self.employee?.picName ?? "")", folder: "images") {[weak self] result in
                                                    switch result {
                                                    case .success((let imageUrl, let imageName)):
                                                        employee.picUrl = imageUrl
                                                        employee.picName = imageName
                                                        self?.vm.update(empId: empId, employee: employee) {[weak self] result in
                                                            switch result {
                                                            case .success(_):
                                                                self?.navigationController?.popViewController(animated: true)
                                                            case .failure(let error):
                                                                self?.present(UIAlertController(title: "Alert!", message: error.localizedDescription, preferredStyle: .alert), animated: true)
                                                            }
                                                        }
                                                    case .failure(let error):
                                                        self?.present(UIAlertController(title: "Alert!", message: error.localizedDescription, preferredStyle: .alert), animated: true)
                        
                                                    }
                        
                                                }
                    } else {
                                                vm.uploadProfileImage(imageData: imageData, name: "\(UUID().uuidString).png", folder: "images") {[weak self] result in
                                                    switch result {
                                                    case .success((let imageUrl, let imageName)):
                                                        employee.picUrl = imageUrl
                                                        employee.picName = imageName
                                                        self?.vm.update(empId: empId, employee: employee) {[weak self] result in
                                                            switch result {
                                                            case .success(_):
                                                                self?.navigationController?.popViewController(animated: true)
                                                            case .failure(let error):
                                                                self?.present(UIAlertController(title: "Alert!", message: error.localizedDescription, preferredStyle: .alert), animated: true)
                                                            }
                                                        }
                                                    case .failure(let error):
                                                        self?.present(UIAlertController(title: "Alert!", message: error.localizedDescription, preferredStyle: .alert), animated: true)
                        
                                                    }
                        
                                                }

                    }
                }
            } else {
                self.vm.update(empId: empId, employee: employee) {[weak self] result in
                    switch result {
                    case .success(_):
                        self?.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        self?.present(UIAlertController(title: "Alert!", message: error.localizedDescription, preferredStyle: .alert), animated: true)
                    }
                }
            }
            
        } else {
            if isProfileImageChanged {
                if let imageData = self.profileImage.backgroundImage(for: .normal)?.pngData() {
                    vm.uploadProfileImage(imageData: imageData, name: "\(UUID().uuidString).png", folder: "images") {[weak self] result in
                        switch result {
                        case .success((let imageUrl, let imageName)):
                            employee.picUrl = imageUrl
                            employee.picName = imageName
                            self?.vm.add(employee: employee) {[weak self] result in
                                switch result {
                                case .success(_):
                                    self?.navigationController?.popViewController(animated: true)
                                case .failure(let error):
                                    self?.present(UIAlertController(title: "Alert!", message: error.localizedDescription, preferredStyle: .alert), animated: true)
                                }
                            }
                        case .failure(let error):
                            self?.present(UIAlertController(title: "Alert!", message: error.localizedDescription, preferredStyle: .alert), animated: true)

                        }
                    }
                } else {
                    self.present(UIAlertController(title: "Alert!", message: "Selected is not in good format", preferredStyle: .alert), animated: true)
                }
            } else {
                self.vm.add(employee: employee) {[weak self] result in
                    switch result {
                    case .success(_):
                        self?.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        self?.present(UIAlertController(title: "Alert!", message: error.localizedDescription, preferredStyle: .alert), animated: true)
                    }
                }
            }
        }
        
    }
    
    @IBAction func changeImageTapped(_ sender: UIButton) {
        if sender.backgroundImage(for: .normal) == UIImage(systemName: "person.crop.circle") {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
            
        } else {
            let actionSheet = UIAlertController(title: "Choose Option",message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive){_ in
                self.profileImage.setBackgroundImage(UIImage(systemName: "person.crop.circle"), for: .normal)
                if let profilePic = self.employee?.picName, !profilePic.isEmpty {
                    self.vm.deleteProfileImage(url: profilePic) {[weak self] result in
                        switch result {
                        case .success(_):
                            self?.employee?.picName = ""
                            self?.employee?.picUrl = ""
                            self?.isProfileImageChanged = false
                            if let empId = self?.employee?.docId,  let employee = self?.employee {
                                self?.vm.update(empId: empId, employee: employee) {[weak self] result in
                                    switch result {
                                    case .success(_):
                                        self?.navigationController?.popViewController(animated: true)
                                    case .failure(let error):
                                        self?.present(UIAlertController(title: "Alert!", message: error.localizedDescription, preferredStyle: .alert), animated: true)
                                    }
                                }
                            }
                            
                        case .failure(_):
                            if let image = self?.employee?.picUrl, let url = URL(string: image) {
                                self?.profileImage.kf.setBackgroundImage(with: url, for: .normal)
                            }
                        }
                    }
                }
            })
            actionSheet.addAction(UIAlertAction(title: "Change", style: .default) {_ in
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true)
            })
            present(actionSheet, animated: true)
        }
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SetEmployeeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            isProfileImageChanged = true
            profileImage.setBackgroundImage(image, for: .normal)
            dismiss(animated: true)
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
