//
// RegistrationFormViewController.swift
// Zentry
//
// Created by Pavel Kuzmin on 2019-03-28.
// Copyright © 2019 Gaika Group. All rights reserved.
//

import UIKit

class RegistrationFormViewController: UIViewController {
    private let kDownIcon = UIImage.init(named: "FilterArrowDownIcon")

    private var registrationInfo: RegistrationInfo = RegistrationInfo()

    @IBOutlet private weak var typeView: AuthorizationTextFieldButtonView!

    @IBOutlet private weak var registrationButton: UIButton!

    var onRegistrationButtonAction: ((RegistrationInfo) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.registrationButton.layer.cornerRadius = self.registrationButton.frame.height / 2

        self.typeView.onChangeTherapistType = { [weak self] therapistType in
            self?.changeTherapistType(therapistType)
        }
    }

    // MARK: - Actions

    @IBAction func registrationButtonTapped() {
        self.view.endEditing(true)
        self.onRegistrationButtonAction?(self.registrationInfo)
    }

    // MARK: - Private function

    private func changeTherapistType(_ therapistType: TherapistType) {
        self.registrationInfo.type = therapistType
    }
}

extension RegistrationFormViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            self.registrationInfo.email = textField.text
        case 2:
            textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
            var firstName = textField.text
            var lastName: String? = ""
            if let range = textField.text?.range(of: " ") {
                firstName = textField.text?.substring(to: range.lowerBound).capitalized
                lastName = textField.text?.substring(from: range.upperBound).capitalized
            }

            self.registrationInfo.firstName = firstName
            self.registrationInfo.lastName = lastName
        case 3:
            if !textField.isSecureTextEntry {
                textField.isSecureTextEntry = true
                if let showSecureButton = textField.rightView as? UIButton {
                    showSecureButton.setImage(UIImage(named: "ShowPasswordIcon"), for: .normal)
                }
            }
            self.registrationInfo.password = textField.text
        case 4:
            if !textField.isSecureTextEntry {
                textField.isSecureTextEntry = true
                if let showSecureButton = textField.rightView as? UIButton {
                    showSecureButton.setImage(UIImage(named: "ShowPasswordIcon"), for: .normal)
                }
            }
            self.registrationInfo.confirmPassword = textField.text
        default:
            if let rightImageView = textField.rightView as? UIImageView {
                rightImageView.image = kDownIcon
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }
}
