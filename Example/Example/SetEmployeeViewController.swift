//
//  SetEmployeeViewController.swift
//  Example
//
//  Copyright © 2023 DevCrew I/O.
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
    var fsEmployee: FSEmployee?
    var dbEmployee: DBEmployee?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " Add Employee"
        
        if let fsEmployee = fsEmployee {
            nameTF.text =  fsEmployee.name
            jobTitleTF.text = fsEmployee.jobTitle
            depTF.text = fsEmployee.department
            mangarTF.text = fsEmployee.manger
            emailTF.text = fsEmployee.email
            phoneTF.text = fsEmployee.phone
            aboutTextView.text = (fsEmployee.about?.isEmpty ?? false) ? "About" : fsEmployee.about
            addressTV.text = (fsEmployee.address?.isEmpty ?? false) ? "Address" : fsEmployee.address
            title = "Edit Employee"
            setButton.setTitle("Update", for: .normal)
            if let imagepath = fsEmployee.picUrl, !imagepath.isEmpty, let url = URL(string: imagepath) {
                profileImage.kf.setBackgroundImage(with: url, for: .normal, placeholder: UIImage(systemName: "person.crop.circle"))
            }

        }
        if let dbEmployee = dbEmployee {
            nameTF.text =  dbEmployee.name
            jobTitleTF.text = dbEmployee.jobTitle
            depTF.text = dbEmployee.department
            mangarTF.text = dbEmployee.manger
            emailTF.text = dbEmployee.email
            phoneTF.text = dbEmployee.phone
            aboutTextView.text = (dbEmployee.about?.isEmpty ?? false) ? "About" : dbEmployee.about
            addressTV.text = (dbEmployee.address?.isEmpty ?? false) ? "Address" : dbEmployee.address
            title = "Edit Employee"
            setButton.setTitle("Update", for: .normal)
            if let imagepath = dbEmployee.picUrl, !imagepath.isEmpty, let url = URL(string: imagepath) {
                profileImage.kf.setBackgroundImage(with: url, for: .normal, placeholder: UIImage(systemName: "person.crop.circle"))
            }
        }
        profileImage.layer.cornerRadius = 50.0
        profileImage.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    @IBAction func setButtonTapped(_ sender: UIButton) {
        if AppController.shared.operationType == .database {
            var dbEmployee = DBEmployee()
            dbEmployee.name = nameTF.text ?? ""
            dbEmployee.jobTitle = jobTitleTF.text ?? ""
            dbEmployee.department = depTF.text ?? ""
            dbEmployee.about = aboutTextView.text == "About" ? "" : aboutTextView.text ?? ""
            dbEmployee.address = addressTV.text == "Address" ? "" : addressTV.text
            dbEmployee.manger = mangarTF.text
            dbEmployee.phone = phoneTF.text
            dbEmployee.email = emailTF.text
            if let id = self.dbEmployee?.nodeId, !id.isEmpty {
                if isProfileImageChanged {
                    if let imageData = self.profileImage.backgroundImage(for: .normal)?.pngData() {
                        if let picName = dbEmployee.picName, !picName.isEmpty {
                            vm.updateProfileImage(imageData: imageData, name: "\(self.dbEmployee?.picName ?? "")", folder: "images") {[weak self] result in
                                                        switch result {
                                                        case .success((let imageUrl, let imageName)):
                                                            dbEmployee.picUrl = imageUrl
                                                            dbEmployee.picName = imageName
                                                            self?.vm.update(id: id, dbEmployee: dbEmployee) {[weak self] result in
                                                                switch result {
                                                                case .success(_):
                                                                    self?.navigationController?.popViewController(animated: true)
                                                                case .failure(let error):
                                                                    AppUtils.showAlert(message: error.localizedDescription, controller: self)
                                                                }
                                                            }
                                                        case .failure(let error):
                                                            AppUtils.showAlert(message: error.localizedDescription, controller: self)
                            
                                                        }
                            
                                                    }
                        } else {
                                                    vm.uploadProfileImage(imageData: imageData, name: "\(UUID().uuidString).png", folder: "images") {[weak self] result in
                                                        switch result {
                                                        case .success((let imageUrl, let imageName)):
                                                            dbEmployee.picUrl = imageUrl
                                                            dbEmployee.picName = imageName
                                                            self?.vm.update(id: id, dbEmployee: dbEmployee) {[weak self] result in
                                                                switch result {
                                                                case .success(_):
                                                                    self?.navigationController?.popViewController(animated: true)
                                                                case .failure(let error):
                                                                    AppUtils.showAlert(message: error.localizedDescription, controller: self)
                                                                }
                                                            }
                                                        case .failure(let error):
                                                            AppUtils.showAlert(message: error.localizedDescription, controller: self)

                                                        }
                            
                                                    }

                        }
                    }
                } else {
                    self.vm.update(id: id, dbEmployee: dbEmployee) {[weak self] result in
                        switch result {
                        case .success(_):
                            self?.navigationController?.popViewController(animated: true)
                        case .failure(let error):
                            AppUtils.showAlert(message: error.localizedDescription, controller: self)
                        }
                    }
                }
                
            } else {
                if isProfileImageChanged {
                    if let imageData = self.profileImage.backgroundImage(for: .normal)?.pngData() {
                        vm.uploadProfileImage(imageData: imageData, name: "\(UUID().uuidString).png", folder: "images") {[weak self] result in
                            switch result {
                            case .success((let imageUrl, let imageName)):
                                dbEmployee.picUrl = imageUrl
                                dbEmployee.picName = imageName
                                self?.vm.add(dbEmployee: dbEmployee) {[weak self] result in
                                    switch result {
                                    case .success(_):
                                        self?.navigationController?.popViewController(animated: true)
                                    case .failure(let error):
                                        AppUtils.showAlert(message: error.localizedDescription, controller: self)
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
                    self.vm.add(dbEmployee: dbEmployee) {[weak self] result in
                        switch result {
                        case .success(_):
                            self?.navigationController?.popViewController(animated: true)
                        case .failure(let error):
                            AppUtils.showAlert(message: error.localizedDescription, controller: self)
                        }
                    }
                }
            }

        } else {
            var fsEmployee = FSEmployee()
            fsEmployee.name = nameTF.text ?? ""
            fsEmployee.jobTitle = jobTitleTF.text ?? ""
            fsEmployee.department = depTF.text ?? ""
            fsEmployee.about = aboutTextView.text == "About" ? "" : aboutTextView.text ?? ""
            fsEmployee.address = addressTV.text == "Address" ? "" : addressTV.text
            fsEmployee.manger = mangarTF.text
            fsEmployee.phone = phoneTF.text
            fsEmployee.email = emailTF.text
            if let empId = self.fsEmployee?.docId, !empId.isEmpty {
                if isProfileImageChanged {
                    if let imageData = self.profileImage.backgroundImage(for: .normal)?.pngData() {
                        if let picName = fsEmployee.picName, !picName.isEmpty {
                            vm.updateProfileImage(imageData: imageData, name: "\(self.fsEmployee?.picName ?? "")", folder: "images") {[weak self] result in
                                                        switch result {
                                                        case .success((let imageUrl, let imageName)):
                                                            fsEmployee.picUrl = imageUrl
                                                            fsEmployee.picName = imageName
                                                            self?.vm.update(empId: empId, fsEmployee: fsEmployee) {[weak self] result in
                                                                switch result {
                                                                case .success(_):
                                                                    self?.navigationController?.popViewController(animated: true)
                                                                case .failure(let error):
                                                                    AppUtils.showAlert(message: error.localizedDescription, controller: self)
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
                                                            fsEmployee.picUrl = imageUrl
                                                            fsEmployee.picName = imageName
                                                            self?.vm.update(empId: empId, fsEmployee: fsEmployee) {[weak self] result in
                                                                switch result {
                                                                case .success(_):
                                                                    self?.navigationController?.popViewController(animated: true)
                                                                case .failure(let error):
                                                                    AppUtils.showAlert(message: error.localizedDescription, controller: self)
                                                                }
                                                            }
                                                        case .failure(let error):
                                                            AppUtils.showAlert(message: error.localizedDescription, controller: self)

                                                        }
                            
                                                    }

                        }
                    }
                } else {
                    self.vm.update(empId: empId, fsEmployee: fsEmployee) {[weak self] result in
                        switch result {
                        case .success(_):
                            self?.navigationController?.popViewController(animated: true)
                        case .failure(let error):
                            AppUtils.showAlert(message: error.localizedDescription, controller: self)
                        }
                    }
                }
                
            } else {
                if isProfileImageChanged {
                    if let imageData = self.profileImage.backgroundImage(for: .normal)?.pngData() {
                        vm.uploadProfileImage(imageData: imageData, name: "\(UUID().uuidString).png", folder: "images") {[weak self] result in
                            switch result {
                            case .success((let imageUrl, let imageName)):
                                fsEmployee.picUrl = imageUrl
                                fsEmployee.picName = imageName
                                self?.vm.add(fsEmployee: fsEmployee) {[weak self] result in
                                    switch result {
                                    case .success(_):
                                        self?.navigationController?.popViewController(animated: true)
                                    case .failure(let error):
                                        AppUtils.showAlert(message: error.localizedDescription, controller: self)
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
                    self.vm.add(fsEmployee: fsEmployee) {[weak self] result in
                        switch result {
                        case .success(_):
                            self?.navigationController?.popViewController(animated: true)
                        case .failure(let error):
                            AppUtils.showAlert(message: error.localizedDescription, controller: self)
                        }
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
                if let profilePic = (AppController.shared.operationType == .firestore ? self.fsEmployee?.picName : self.dbEmployee?.picName), !profilePic.isEmpty {
                    self.vm.deleteProfileImage(url: profilePic) {[weak self] result in
                        switch result {
                        case .success(_):
                            if AppController.shared.operationType == .firestore {
                                self?.fsEmployee?.picName = ""
                                self?.fsEmployee?.picUrl = ""
                                self?.isProfileImageChanged = false
                                if let empId = self?.fsEmployee?.docId,  let fsEmployee = self?.fsEmployee {
                                    self?.vm.update(empId: empId, fsEmployee: fsEmployee) {[weak self] result in
                                        switch result {
                                        case .success(_):
                                            self?.navigationController?.popViewController(animated: true)
                                        case .failure(let error):
                                            AppUtils.showAlert(message: error.localizedDescription, controller: self)
                                        }
                                    }
                                }
                            } else {
                                self?.dbEmployee?.picName = ""
                                self?.dbEmployee?.picUrl = ""
                                self?.isProfileImageChanged = false
                                if let empId = self?.dbEmployee?.nodeId,  let dbEmployee = self?.dbEmployee {
                                    self?.vm.update(id: empId, dbEmployee: dbEmployee) {[weak self] result in
                                        switch result {
                                        case .success(_):
                                            self?.navigationController?.popViewController(animated: true)
                                        case .failure(let error):
                                            AppUtils.showAlert(message: error.localizedDescription, controller: self)
                                        }
                                    }
                                }
                            }
                        case .failure(_):
                            if let image = (AppController.shared.operationType == .firestore ? self?.fsEmployee?.picUrl : self?.dbEmployee?.picUrl), let url = URL(string: image) {
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
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel) {_ in
                self.dismiss(animated: true)
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
