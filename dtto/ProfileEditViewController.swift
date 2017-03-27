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
    func updateEducation(education: String)
    func showImagePicker()
}

class ProfileEditViewController: UIViewController, FormNavigationBar {

    var user: User
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
//        tv.backgroundColor = .white
        tv.estimatedRowHeight = 50
//        tv.estimatedSectionHeaderHeight = 20
//        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = true
        
        tv.register(EditUserInfoBaseCell.self, forCellReuseIdentifier: "EditUserInfoBaseCell")
        tv.register(EditUserImageCell.self, forCellReuseIdentifier: "EditUserImageCell")
        tv.register(EditUserSummaryCell.self, forCellReuseIdentifier: "EditUserSummaryCell")
        return tv
    }()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        hideKeyboardWhenTappedAround()
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
    
    private func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        updateName()
        updateBirthday()
//        selectPicture()
        
        let userUpdates = user.createUserDict()
        
        guard let userID = defaults.getUID() else { return }
        
        let userRef = FIREBASE_REF.child("users").child(userID)
        userRef.updateChildValues(userUpdates)
        
    }
    
    func enableSaveButton() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.tintColor = Color.darkNavy
    }
    
    private func updateName() {
        
        guard let userID = defaults.getName(), let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? EditUserInfoBaseCell else { return }

        guard let nameField = cell.userInfoTextView.text, let name = user.name, name != nameField else { return }
        
        let nameRef = FIREBASE_REF.child("users").child(userID).child("name")
        nameRef.setValue(name)

    }
    
    private func updateBirthday() {
        
        guard let userID = defaults.getUID(), let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? EditUserInfoBaseCell else { return }
   
        let birthdayRef = FIREBASE_REF.child(userID).child("birthday")
        
        if let birthdayField = cell.userInfoTextView.text, birthdayField != "Add your birthday" {
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
        case Expertise
        case Summary
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
            
        case .Image:
            return 1
        case .Name:
            return 1
        case .Birthday:
            return 1
        case .Education:
            return addUserInfoLine(count: user.education.count)
        case .Profession:
            return addUserInfoLine(count: user.profession.count)
        case .Expertise:
            return addUserInfoLine(count: user.expertise.count)
        case .Summary:
            return 1
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
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        
//        if tableView.numberOfRows(inSection: section) != 0 {
//            
//            guard let section = Section(rawValue: section) else { return 0 }
//            
//            switch section {
//            case .Education, .Profession, .Expertise, .Summary:
//                return 30
//            default:
//                return 0
//            }
//            
//        }
//        else {
//            return 0
//        }
//        
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
            
        case .Image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditUserImageCell") as! EditUserImageCell
            cell.profileViewControllerDelegate = self
            cell.profileImage.setBackgroundImage(#imageLiteral(resourceName: "profile"), for: UIControlState())
            cell.selectionStyle = .none
            return cell
  
        case .Summary:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditUserSummaryCell") as! EditUserSummaryCell
            cell.selectionStyle = .none
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditUserInfoBaseCell") as! EditUserInfoBaseCell
            cell.selectionStyle = .none
            
            switch section {
                
            case .Name:
                cell.infoLabel.text = "Name"
                cell.userInfoTextView.text = user.name ?? "Add your name"
            
            case .Birthday:
                cell.infoLabel.text = "Birthday"
                cell.userInfoTextView.text = user.birthday ?? "Add your birthday"
                cell.userInfoTextView.isUserInteractionEnabled = false
            
            case .Education:
                if indexPath.row == 0 {
                    cell.infoLabel.text = "Education"
                }
                else {
                    cell.infoLabel.text = nil
                }
                if indexPath.row >= user.education.count {
                    // make new cell
                    cell.userInfoTextView.text = "Add a school"
                    cell.userInfoTextView.isUserInteractionEnabled = false
                    cell.selectionStyle = .default
                }
                else {
                    cell.userInfoTextView.text = user.education[indexPath.row]
                }

            case .Profession:
                if indexPath.row == 0 {
                    cell.infoLabel.text = "Profession"
                }
                else {
                    cell.infoLabel.text = nil
                }
                if indexPath.row >= user.profession.count {
                    // make new cell
                    cell.userInfoTextView.text = "Add a profession"
                    cell.userInfoTextView.isUserInteractionEnabled = false
                    cell.selectionStyle = .default
                }
                else {
                    cell.userInfoTextView.text = user.profession[indexPath.row]
                }
            
            case .Expertise:
                if indexPath.row == 0 {
                    cell.infoLabel.text = "Expertise"
                }
                else {
                    cell.infoLabel.text = nil
                }
                if indexPath.row >= user.expertise.count {
                    cell.userInfoTextView.text = "Add an expertise"
                    cell.userInfoTextView.isUserInteractionEnabled = false
                    cell.selectionStyle = .default
                }
                else {
                    cell.userInfoTextView.text = user.expertise[indexPath.row]
                }
            
            default:
                return UITableViewCell()
            }
            
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
            
        case .Name:
            guard let nameCell = tableView.cellForRow(at: indexPath) as? EditUserInfoBaseCell else { return }
            _ = nameCell.userInfoTextView.becomeFirstResponder()
            
        case .Birthday:
            let datePickerVC = DatePickerViewController()
            datePickerVC.mainEditDelegate = self
            present(UINavigationController(rootViewController: datePickerVC), animated: true, completion: nil)
            
        case .Education:
            if indexPath.row >= user.education.count {
                
                let autocompleteController = GMSAutocompleteViewController()
                let filter = GMSAutocompleteFilter()
                filter.type = .establishment
                autocompleteController.autocompleteFilter = filter
                autocompleteController.delegate = self
                
                present(autocompleteController, animated: true, completion: nil)

//                let vc = UserInfoPickerViewController(UserInfoType.Education)
//                present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
        case .Profession:
            if indexPath.row >= user.profession.count {
                let vc = UserInfoPickerViewController(UserInfoType.Profession)
                vc.mainEditDelegate = self
                present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
        case .Expertise:
            if indexPath.row >= user.expertise.count {
                let vc = UserInfoPickerViewController(UserInfoType.Expertise)
                vc.mainEditDelegate = self
                present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
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
            cell.userInfoTextView.text = "\(date)"
            user.birthday = "\(date)"
        }
        else {
            cell.userInfoTextView.text = "Add your birthday"
        }
        
        enableSaveButton()
        
    }
    
    func updateEducation(education: String) {
        
        var userEducation = user.education
        userEducation.append(education)
        
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
    
    func addTableViewCell(infoType: UserInfoType, placeName: String) {
        
        switch infoType {
        case .Education:
            
            user.education.append(placeName)
            
            let educationCount = user.education.count
            
            if educationCount < 3 {
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [IndexPath(row: educationCount, section: 3)], with: .automatic)
                    self.tableView.endUpdates()
                }
            }
            
            guard let cell = tableView.cellForRow(at: IndexPath(row: user.education.count-1, section: 3)) as? EditUserInfoBaseCell else { return }
            cell.userInfoTextView.text = placeName
            
            
        case .Profession:
            
            user.profession.append(placeName)
            
            let professionCount = user.profession.count
            
            if professionCount < 3 {
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [IndexPath(row: professionCount, section: 4)], with: .automatic)
                    self.tableView.endUpdates()
                }
            }

            guard let cell = tableView.cellForRow(at: IndexPath(row: user.profession.count-1, section: 4)) as? EditUserInfoBaseCell else { return }
            cell.userInfoTextView.text = placeName

            
        case .Expertise:
            
            let expertiseCount = user.expertise.count
            DispatchQueue.main.async {
                self.tableView.insertRows(at: [IndexPath(row: expertiseCount, section: 5)], with: .automatic)
            }
        }
        
    }
    
}

extension ProfileEditViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        addTableViewCell(infoType: .Education, placeName: place.name)
        
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
