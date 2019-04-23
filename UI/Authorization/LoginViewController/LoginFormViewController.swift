//
//  LoginFormViewController.swift
//  DaTracker
//
//  Created by Pavel Kuzmin on 19.10.2018.
//  Copyright © 2018 Gaika Group. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginFormViewController: UIViewController {
    private var credential: LoginCredential = LoginCredential()
    private let laContext = AuthorizationController.shared.laContext
    
    @IBOutlet private weak var loginTitleView: TitleView!
    @IBOutlet private weak var loginButton: UIButton!

    @IBOutlet private weak var biometricsButton: UIButton!

    var onLoginButtonAction: ((LoginCredential) -> Void)?
    var onBiometricsButtonAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginButton.layer.cornerRadius = self.loginButton.frame.height / 2

#if targetEnvironment(simulator)
        self.credential.username = LoginCredentialMock.Behavior().username
        self.credential.password = LoginCredentialMock.Behavior().password
#endif

        if #available(iOS 11.0, *) {
            if self.laContext.biometryType == .faceID {
                let image = UIImage.init(named: "FaceIDIcon")
                self.biometricsButton.setImage(image, for: .normal)
            }
        }

        if AuthorizationController.shared.biometricsAvailable &&
                   UserDefaults.standard.bool(forKey: AuthorizationController.Keys.useBiometrics) {
            self.biometricsButton.isHidden = false
        }
    }

    // MARK: - Actions

    @IBAction func loginButtonTapped() {
        self.view.endEditing(true)
        self.onLoginButtonAction?(self.credential)
    }

    @IBAction func biometricsButtonTapped() {
        self.view.endEditing(true)
        self.onBiometricsButtonAction?()
    }
}

extension LoginFormViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            if !textField.isSecureTextEntry {
                textField.isSecureTextEntry = true
                if let showSecureButton = textField.rightView as? UIButton {
                    showSecureButton.setImage(UIImage(named: "ShowPasswordIcon"), for: .normal)
                }
            }
            self.credential.password = textField.text
        default:
            self.credential.username = textField.text
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }
}
