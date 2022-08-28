//
//  DetailUsersViewController.swift
//  MyCoreDataProject
//
//  Created by Maksim Malofeev on 28/08/2022.
//

import UIKit

class DetailUsersViewController: UIViewController, UINavigationControllerDelegate {

    var isEdit = true
    private var selectedAvatar: Data? = nil
    var presenter: DetailUsersPresenterProtocol!
    private let imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .savedPhotosAlbum
        picker.allowsEditing = false
        return picker
    }()
    private let datePicker = UIDatePicker()

    // MARK: - Views

    var avatarButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = CGFloat(Metrics.avatarImageViewHeight / 2)
        button.imageView?.layer.cornerRadius = CGFloat(Metrics.avatarImageViewHeight / 2)
        button.imageView?.clipsToBounds = true
        button.imageView?.layer.masksToBounds = true
        button.isEnabled = false
        return button
    }()

    var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.clearButtonMode = .whileEditing
        textField.setIcon(Strings.userNameTextFieldIcon)
        textField.borderStyle = .roundedRect
        textField.isEnabled = false
        return textField
    }()

    var birthOfDateTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.placeholder = Strings.birthOfDateTextFieldPlaceholder
        textField.setIcon(Strings.birthOfDateTextFieldIcon)
        textField.borderStyle = .roundedRect
        textField.isEnabled = false
        return textField
    }()

    var genderTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Strings.genderTextFieldPlaceholder
        textField.textAlignment = .left
        textField.setIcon(Strings.genderTextFieldIcon)
        textField.borderStyle = .roundedRect
        textField.isEnabled = false
        return textField
    }()

    var genderPickerView: UIPickerView = {
        UIPickerView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
        presenter.getUser()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editInfoUsers))
        setupDatePicker()
        setupGenderPicker()
        imagePicker.delegate = self
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        avatarButton.addTarget(self, action: #selector(avatarButtonTapped), for: .touchUpInside)
    }

    private func setupHierarchy() {
        let subviews = [avatarButton,
                        userNameTextField,
                        birthOfDateTextField,
                        genderTextField]
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)

        }
    }


    private func setupLayout() {

        NSLayoutConstraint.activate([
            avatarButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Metrics.avatarImageViewTopOffset),
            avatarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarButton.heightAnchor.constraint(equalToConstant: Metrics.avatarImageViewHeight),
            avatarButton.widthAnchor.constraint(equalToConstant: Metrics.avatarImageViewHeight),

            userNameTextField.topAnchor.constraint(equalTo: avatarButton.bottomAnchor, constant: Metrics.primaryTopOffset),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.primaryLeftOffset),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metrics.primaryRightOffset),
            userNameTextField.heightAnchor.constraint(equalToConstant: Metrics.primaryHeight),

            birthOfDateTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: Metrics.primaryTopOffset),
            birthOfDateTextField.leadingAnchor.constraint(equalTo: userNameTextField.leadingAnchor),
            birthOfDateTextField.trailingAnchor.constraint(equalTo: userNameTextField.trailingAnchor),
            birthOfDateTextField.heightAnchor.constraint(equalTo: userNameTextField.heightAnchor),

            genderTextField.topAnchor.constraint(equalTo: birthOfDateTextField.bottomAnchor, constant: Metrics.primaryTopOffset),
            genderTextField.leadingAnchor.constraint(equalTo: birthOfDateTextField.leadingAnchor),
            genderTextField.trailingAnchor.constraint(equalTo: birthOfDateTextField.trailingAnchor),
            genderTextField.heightAnchor.constraint(equalTo: birthOfDateTextField.heightAnchor),
        ])
    }

    func setAvatar(_ avatar: Data) {
        avatarButton.setImage(UIImage(data: avatar), for: .normal)
        avatarButton.setImage(UIImage(data: avatar), for: .disabled)
    }

    private func setupDatePicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        birthOfDateTextField.inputAccessoryView = toolBar
        birthOfDateTextField.inputView = datePicker

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self,
                             action: #selector(chooseDate(datePicker:)),
                             for: UIControl.Event.valueChanged)
    }

    private func setupGenderPicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: nil,
            action: #selector(doneButtonPressed))
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        genderTextField.inputAccessoryView = toolBar
        genderTextField.inputView = genderPickerView
    }

    @objc private func editInfoUsers() {
        isEdit.toggle()
        navigationItem.rightBarButtonItem?.title = isEdit ? "Edit" : "Save"
        avatarButton.isEnabled.toggle()
        userNameTextField.isEnabled.toggle()
        birthOfDateTextField.isEnabled.toggle()
        genderTextField.isEnabled.toggle()

        presenter.updateUser(
            presenter.user ?? User(),
            newName: userNameTextField.text,
            dateOfBirth: birthOfDateTextField.text,
            gender: genderTextField.text,
            avatar: selectedAvatar)
    }

    @objc private func avatarButtonTapped() {
        present(imagePicker, animated: true, completion: nil)
    }

    @objc private func doneButtonPressed() {
        self.view.endEditing(true)
    }

    @objc private func chooseDate(datePicker: UIDatePicker) {
        birthOfDateTextField.text = datePicker.date.convertToString()
    }
}

extension DetailUsersViewController: DetailUsersViewProtocol {
    func setUser(_ user: User?) {
        userNameTextField.text = presenter.user?.name
        birthOfDateTextField.text = presenter.user?.dateOfBirth?.convertToString()
        genderTextField.text = presenter.user?.gender

        DispatchQueue.main.async {
            if let avatar = self.presenter.user?.avatar {
                self.setAvatar(avatar)
            }
        }
    }
}

extension DetailUsersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension DetailUsersViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }

        DispatchQueue.main.async {
            let scaledImage = image.scaleTo(targetSize: CGSize(width: 100, height: 100))
            self.selectedAvatar = scaledImage.pngData()

            if let avatar = self.selectedAvatar {
                self.setAvatar(avatar)
            }
        }
    }
}

extension DetailUsersViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Strings.genders.count
    }
}

// MARK: - UIPickerViewDelegate

extension DetailUsersViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Strings.genders[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row != 0 else { return }
        genderTextField.text = Strings.genders[row]
    }
}

extension DetailUsersViewController {
    enum Metrics {
        static let avatarImageViewTopOffset: CGFloat = 100
        static let avatarImageViewHeight: CGFloat = 200

        static let primaryTopOffset: CGFloat = 20
        static let primaryLeftOffset: CGFloat = 15
        static let primaryRightOffset: CGFloat = -15
        static let primaryHeight: CGFloat = 60
    }

    enum Strings {
        static let genders = ["Choose gender", "Male", "Female"]
        static let buttonTitle = "Add avatar"
        static let userNameTextFieldIcon = "person"
        static let birthOfDateTextFieldIcon = "calendar"
        static let genderTextFieldIcon = "person.2.circle"

        static let birthOfDateTextFieldPlaceholder = "Enter your birth date"
        static let genderTextFieldPlaceholder = "Choose your gender"
    }
}

