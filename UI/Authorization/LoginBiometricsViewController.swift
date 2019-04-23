//
// LoginBiometricsViewController.swift
// DaTracker
//
// Created by Pavel Kuzmin on 2018-12-03.
// Copyright © 2018 Gaika Group. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginBiometricsViewController: AuthorizationViewController, IShowAlertViewController {
    @IBOutlet internal weak var touchIDLabel: UILabel!
    @IBOutlet internal weak var touchIDButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            if self.laContext.biometryType == .faceID {
                let image = UIImage.init(named: "FaceIDIcon")
                self.touchIDButton.setImage(image, for: .normal)
                self.touchIDLabel.text = "Login with Face ID"
            }
        }
    }

    // MARK: - Actions

    @IBAction func touchIDButtonTapped() {
        self.activityIndicator.startAnimating()

        AuthorizationController.shared.biometricsLogin() { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()

                    guard let nsError: NSError = error as? NSError, nsError.code != LAError.userCancel.rawValue else {
                        return
                    }

                    if nsError.code == LAError.userFallback.rawValue {
                        self?.showAlert(withTitle: "", andMessage: "Please, use \"Login with username\" button below for authorization.")
                    }
                    else {
                        self?.showAlert(withTitle: "", andMessage: error.localizedDescription)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.completeAction?()
                }
            }
        }
    }

    @IBAction func loginUsernameButtonTapped() {
        if let loginViewController = self.storyboard?.instantiateViewController(with: LoginViewController.self) {
            loginViewController.completeAction = self.completeAction
            UIView.transition(with: self.navigationController!.view, duration: 1.0, options: .transitionFlipFromRight, animations: {
                self.show(loginViewController, sender: nil)
            }, completion: nil)
        }
    }
}
