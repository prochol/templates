//
// ForgotPasswordViewController.swift
// DaTracker
//
// Created by Pavel Kuzmin on 2018-12-14.
// Copyright © 2018 Gaika Group. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: AuthorizationViewController, IShowErrorViewController {
    @IBOutlet private weak var forgotPasswordFormContainer: UIView!

    @IBOutlet private weak var loginButton: UIButton!

    @IBOutlet private weak var keypadOffsetConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.forgotPasswordFormContainer.layer.cornerRadius = 7.5

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

        let forgotPasswordFormViewController = segue.destination as? ForgotPasswordFormViewController
        forgotPasswordFormViewController?.onForgotPasswordButtonAction = { [weak self] forgotPasswordMail in
            self?.forgotPassword(with: forgotPasswordMail)
        }
    }

    // MARK: - Actions

    @IBAction func loginButtonTapped() {
        if let navigationController = self.navigationController {
            UIView.transition(with: navigationController.view, duration: 1.0, options: .transitionFlipFromRight, animations: {
                navigationController.popViewController(animated: true)
            }, completion: nil)
        }
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

    private func forgotPassword(with email: String) {
        if email.isEmpty {
            self.showAlert(withTitle: "", andMessage: LS("authorization.error.emptyField"))
            return
        }

        self.activityIndicator.startAnimating()

        AuthorizationController.shared.forgotPassword(with: email) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.show(error: error)
                }
            }
            else {
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.showAlertSuccess(withCompletion: self?.completeAction)
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
extension ForgotPasswordViewController {
    private func showAlertSuccess(withCompletion completion: (() -> Void)?) {
        let alert = self.alertSuccess(withCompletion: completion)
        self.present(alert, animated: true)
    }

    private func alertSuccess(withCompletion completion: (() -> Void)?) -> UIAlertController {
        let title = LS("authorization.forgot.success.title")
        let message = LS("authorization.forgot.success.message")

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: LS("general.button.ok"), style: .cancel, handler: { (aAction) in
            completion?()
        }))

        return alert
    }
}