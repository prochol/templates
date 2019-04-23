//
// ForgotPasswordFormViewController.swift
// DaTracker
//
// Created by Pavel Kuzmin on 2018-12-14.
// Copyright © 2018 Gaika Group. All rights reserved.
//

import UIKit

class ForgotPasswordFormViewController: UIViewController {
    private var forgotPasswordEmail: String = ""

    @IBOutlet private weak var forgotPasswordButton: UIButton!

    var onForgotPasswordButtonAction: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.forgotPasswordButton.layer.cornerRadius = self.forgotPasswordButton.frame.height / 2

#if targetEnvironment(simulator)
        self.forgotPasswordEmail = "test@test.ru"
#endif
    }

    // MARK: - Actions

    @IBAction func forgotPasswordButtonTapped() {
        self.view.endEditing(true)
        self.onForgotPasswordButtonAction?(self.forgotPasswordEmail)
    }
}

extension ForgotPasswordFormViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.forgotPasswordEmail = textField.text ?? ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }
}
