//
// AuthorizationTextFieldView.swift
// DaTracker
//
// Created by Pavel Kuzmin on 2018-12-03.
// Copyright © 2018 Gaika Group. All rights reserved.
//

import UIKit

@IBDesignable
class AuthorizationTextFieldView: UIView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!

    @IBInspectable var isSecureTextEntry: Bool {
        set {
            if self.textField != nil {
                self.textField.isSecureTextEntry = isSecureTextEntry
                if let imageView = self.textField.rightView as? UIImageView {
                    imageView.image = isSecureTextEntry ? UIImage(named: "PasswordIcon") : UIImage(named: "UsernameIcon")
                }
            }
        }
        get {
            return self.textField != nil ? self.textField.isSecureTextEntry : false
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.textField.layer.borderWidth = 1.0
        self.textField.layer.borderColor = UIColor.init(r: 224, g: 229, b: 232).cgColor
        self.textField.layer.cornerRadius = 1.0

        let textFieldSize = textField.bounds.size

        self.textField.leftViewMode = .always
        self.textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 11.0, height: textFieldSize.height))

        self.textField.rightViewMode = .always

        if self.isSecureTextEntry {
            let showSecureButton = UIButton(type: .custom)
            showSecureButton.setImage(UIImage(named: "ShowPasswordIcon"), for: .normal)
            showSecureButton.frame = CGRect(x: textFieldSize.width - textFieldSize.height, y: 0, width: textFieldSize.height, height: textFieldSize.height)
            showSecureButton.addTarget(self, action: #selector(self.touchUp), for: .touchUpInside)
            self.textField.rightView = showSecureButton
        }
        else {
            let imageView = UIImageView(frame: CGRect(x: textFieldSize.width - textFieldSize.height, y: 0, width: textFieldSize.height, height: textFieldSize.height))
            imageView.contentMode = .center
            imageView.image = self.isSecureTextEntry ? UIImage(named: "PasswordIcon") : UIImage(named: "UsernameIcon")
            self.textField.rightView = imageView
        }
    }

    // MARK: - Actions

    @objc func touchUp() {
        self.textField.isSecureTextEntry = !self.textField.isSecureTextEntry
        if let existingText = self.textField.text, self.textField.isSecureTextEntry {
            /* When toggling to secure text, all text will be purged if the user
             continues typing unless we intervene. This is prevented by first
             deleting the existing text and then recovering the original text. */
            self.textField.deleteBackward()

            if let textRange = self.textField.textRange(from: self.textField.beginningOfDocument, to: self.textField.endOfDocument) {
                self.textField.replace(textRange, withText: existingText)
            }
        }

        /* Reset the selected text range since the cursor can end up in the wrong
        position after a toggle because the text might vary in width */
        if let existingSelectedTextRange = self.textField.selectedTextRange {
            self.textField.selectedTextRange = nil
            self.textField.selectedTextRange = existingSelectedTextRange
        }

        if let showSecureButton = self.textField.rightView as? UIButton {
            showSecureButton.setImage(self.textField.isSecureTextEntry ? UIImage(named: "ShowPasswordIcon") : UIImage(named: "PasswordIcon"), for: .normal)
        }
    }
}
