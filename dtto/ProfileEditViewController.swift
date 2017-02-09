//
//  ProfileEditViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/16/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase

protocol MainEditViewDelegate {
    
    func updateBirthday(date: Date?)
    func showImagePicker()
}

class ProfileEditViewController: UIViewController,FormNavigationBar {

    var user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        tv.estimatedRowHeight = 50
//        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = true
        
        tv.register(EditUserInfoBaseCell.self, forCellReuseIdentifier: "EditUserInfoBaseCell")
        tv.register(EditUserImageCell.self, forCellReuseIdentifier: "EditUserImageCell")
        tv.register(EditUserSummaryCell.self, forCellReuseIdentifier: "EditUserSummaryCell")
        return tv
    }()
    
    private func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)

        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar(title: "Edit Profile")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let index = self.tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: index, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        updateName()
        updateBirthday()
//        selectPicture()
    }
    
    func enableSaveButton() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.tintColor = Color.darkNavy
    }
    
    private func updateName() {
        
        guard let userID = defaults.getName(), let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? EditUserInfoBaseCell else { return }

        guard let nameField = cell.userInfoTextField.text, let name = user.name, name != nameField else { return }
        
        let nameRef = FIREBASE_REF.child("users").child(userID).child("name")
        nameRef.setValue(name)

    }
    
    private func updateBirthday() {
        
        guard let userID = defaults.getUID(), let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? EditUserInfoBaseCell else { return }
   
        let birthdayRef = FIREBASE_REF.child(userID).child("birthday")
        
        if let birthdayField = cell.userInfoTextField.text, birthdayField != "Add your birthday" {
            if let userBirthday = user.birthday, userBirthday == birthdayField {
  
            }
            else {
                birthdayRef.setValue(birthdayField)
            }
        }
        else {
            birthdayRef.removeValue()
        }
        
    }
    
   

}

 

extension ProfileEditViewController: UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {

        case Image
        case Name
        case Birthday
        case Education
        case Profession
        case Summary
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 5:
            return 1
        default:
            return 0
        }
        
//        guard let section = Section(rawValue: section) else { return 0 }
//        
//        switch section {
//            
//        case .Profile:
//            return 1
//        case .Education:
//            return user.education.count
//        case .Profession:
//            return user.profession.count
//        case .Expertise:
//            return user.expertise.count
//        case .Summary:
//            if let _ = user.summary {
//                return 1
//            }
//            else {
//                return 0
//            }
//        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditUserImageCell") as! EditUserImageCell
            cell.profileViewControllerDelegate = self
            cell.profileImage.setBackgroundImage(#imageLiteral(resourceName: "profile"), for: UIControlState())
            cell.selectionStyle = .none
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditUserInfoBaseCell") as! EditUserInfoBaseCell
            
            switch indexPath.row {
            
            case 0:
                cell.infoLabel.text = "Name"
                cell.userInfoTextField.placeholder = user.name ?? "Add your name"
                cell.selectionStyle = .none
                
            default:
                cell.infoLabel.text = "Birthday"
                cell.userInfoTextField.placeholder = user.birthday ?? "Add your birthday"
                cell.userInfoTextField.isUserInteractionEnabled = false
            }
            
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditUserSummaryCell") as! EditUserSummaryCell
            return cell
        default:
            return UITableViewCell()
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 1:
            switch indexPath.row {
            case 0:
                guard let nameCell = tableView.cellForRow(at: indexPath) as? EditUserInfoBaseCell else { return }
                _ = nameCell.userInfoTextField.becomeFirstResponder()
                
            case 1:
                let datePickerVC = DatePickerViewController()
                datePickerVC.mainEditDelegate = self
                present(UINavigationController(rootViewController: datePickerVC), animated: true, completion: nil)
            default:
                break
            }
        default:
            break
        }
        
    }
}

extension ProfileEditViewController: MainEditViewDelegate {
    
    func updateBirthday(date: Date?) {
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? EditUserInfoBaseCell else { return }
        
        if let date = date {
            cell.userInfoTextField.text = "\(date)"
        }
        else {
            cell.userInfoTextField.text = "Add your birthday"
        }
        
        enableSaveButton()
        
    }
    
    func showImagePicker() {
        selectPicture()
    }
}

extension ProfileEditViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func selectPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditUserImageCell else { return }
        
//        cell.profileImage.setBackgroundImage(newImage, for: UIControlState())
        downloadImageToDisk(newImage)
        uploadProfileImage(newImage)
        dismiss(animated: true)
    }
    
    func downloadImageToDisk(_ image: UIImage) {
        
        guard let userID = defaults.getUID() else { return }
        
        if let data = UIImageJPEGRepresentation(image, 0.1) {
            let filename = getDocumentsDirectory().appendingPathComponent("\(userID)profile.jpg")
            try! data.write(to: filename)
            
            guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditUserImageCell else { return }
            
            if let docImage = UIImage(contentsOfFile: filename.path) {
                cell.profileImage.setBackgroundImage(docImage, for: UIControlState())
            }
            
        }
        
    }
    
    func uploadProfileImage(_ image: UIImage) {
        
        guard let userID = defaults.getUID() else { return }
        
        let storageRef = STORAGE_REF.child("users").child(userID).child("profile.jpg")
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.1) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }

            })
        }
        
    }
    
}

extension ProfileEditViewController: GMSAutocompleteViewControllerDelegate {
    
    //        let autocompleteController = GMSAutocompleteViewController()
    //        let filter = GMSAutocompleteFilter()
    //        filter.type = .establishment
    //        autocompleteController.autocompleteFilter = filter
    //        autocompleteController.delegate = self
    //
    //        present(autocompleteController, animated: true, completion: nil)
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
