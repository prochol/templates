//
// LoginViewController.swift
// DaTracker
//
// Created by Pavel Kuzmin on 19.10.2018.
// Copyright © 2018 Gaika Group. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: AuthorizationViewController, IShowErrorViewController {
    @IBOutlet private weak var loginFormContainer: UIView!

    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!

    @IBOutlet private weak var keypadOffsetConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginFormContainer.layer.cornerRadius = 7.5

        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.unregisterKeyboardNotifications()
        super.viewWillDisappear(animated)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        let loginFormViewController = segue.destination as? LoginFormViewController
        loginFormViewController?.onLoginButtonAction = { [weak self] credential in
            self?.login(with: credential)
        }

        loginFormViewController?.onBiometricsButtonAction = { [weak self] in
            self?.loginBiometrics()
        }
    }

    // MARK: - Actions

    @IBAction func forgotPasswordButtonTapped() {
        if let forgotPasswordViewController = self.storyboard?.instantiateViewController(with: ForgotPasswordViewController.self),
           let navigationController = self.navigationController {
            forgotPasswordViewController.completeAction = {
                UIView.transition(with: navigationController.view, duration: 1.0, options: .transitionFlipFromRight, animations: {
                    navigationController.popViewController(animated: true)
                }, completion: nil)
            }
            UIView.transition(with: navigationController.view, duration: 1.0, options: .transitionFlipFromRight, animations: {
                self.show(forgotPasswordViewController, sender: nil)
            }, completion: nil)
        }

        self.dismiss(animated: true)
    }

    @IBAction func registrationButtonTapped() {
        if let registrationViewController = self.storyboard?.instantiateViewController(with: RegistrationViewController.self),
           let navigationController = self.navigationController {
            registrationViewController.completeAction = self.completeAction
            UIView.transition(with: navigationController.view, duration: 1.0, options: .transitionFlipFromRight, animations: {
                self.show(registrationViewController, sender: nil)
            }, completion: nil)
        }

        self.dismiss(animated: true)
    }


    // MARK: keyboard

    @objc func keyboardDidShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardSizeBegin: NSValue = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
            let keyboardSizeEnd: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue

            let rectBegin = keyboardSizeBegin.cgRectValue
            let rectEnd = keyboardSizeEnd.cgRectValue

            let height = CGFloat.maximum(rectBegin.size.height, rectEnd.size.height)

            self.keypadOffsetConstraint.constant = height
            self.view.layoutSubviews()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        self.keypadOffsetConstraint.constant = 0.0
        self.view.layoutSubviews()
    }

    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }

    // MARK: - Private functions

    private func login(with credentials: LoginCredential) {
        if let error = credentials.validation() {
            self.showAlert(withTitle: "", andMessage: error.localizedDescription)
            return
        }

        self.activityIndicator.startAnimating()

        AuthorizationController.shared.login(with: credentials) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.show(error: error)
                }
            }
            else {
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()

                    if AuthorizationController.shared.biometricsAvailable {
                        self?.showAlertUseBiometrics(withCompletion: self?.completeAction)
                    }
                    else {
                        self?.completeAction?()
                    }
                }
            }
        }
    }

    private func loginBiometrics() {
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

    // MARK: Notifications

    private func registerKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func unregisterKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
// MARK: Utils
extension LoginViewController {
    private func showAlertUseBiometrics(withCompletion completion: (() -> Void)?) {
        let alert = self.alertUseBiometrics(withCompletion: completion)
        self.present(alert, animated: true)
    }

    private func alertUseBiometrics(withCompletion completion: (() -> Void)?) -> UIAlertController {
        var title = LS("authorization.use.biometrics.touchID.title")
        var message = LS("authorization.use.biometrics.touchID.message")

        if #available(iOS 11.0, *) {
            if self.laContext.biometryType == .faceID {
                title = LS("authorization.use.biometrics.faceID.title")
                message = LS("authorization.use.biometrics.faceID.message")
            }
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: LS("general.button.yes"), style: .default, handler: { action in
            UserDefaults.standard.set(true, forKey: AuthorizationController.Keys.useBiometrics)
            //TODO: saved login and password in keychain
            completion?()
        }))
        alert.addAction(UIAlertAction(title: LS("general.button.no"), style: .cancel, handler: { action in
            UserDefaults.standard.set(false, forKey: AuthorizationController.Keys.useBiometrics)

            completion?()
        }))

        return alert
    }
}