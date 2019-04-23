//
// AuthorizationTextFieldButtonView.swift
// Zentry
//
// Created by prochol on 2019-03-29.
// Copyright © 2019 Gaika Group. All rights reserved.
//

import UIKit

class AuthorizationTextFieldButtonView: UIView {
    private let kUpIcon = UIImage.init(named: "FilterArrowUpIcon")
    private let kDownIcon = UIImage.init(named: "FilterArrowDownIcon")

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var changeButton: UIButton!

    private let therapistTypeList = TherapistType.allCases
    private var picker: UIPickerView = UIPickerView()

    var onChangeTherapistType: ((TherapistType) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.textField.layer.borderWidth = 1.0
        self.textField.layer.borderColor = UIColor.init(r: 224, g: 229, b: 232).cgColor
        self.textField.layer.cornerRadius = 1.0

        self.textField.inputAssistantItem.leadingBarButtonGroups = []
        self.textField.inputAssistantItem.trailingBarButtonGroups = []

        let textFieldSize = textField.bounds.size

        self.textField.leftViewMode = .always
        self.textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 11.0, height: textFieldSize.height))

        let imageView = UIImageView(frame: CGRect(x: textFieldSize.width - textFieldSize.height, y: 0, width: textFieldSize.height, height: textFieldSize.height))
        imageView.contentMode = .center
        imageView.image = self.changeButton.tag > 0 ? kUpIcon : kDownIcon
        self.textField.rightViewMode = .always
        self.textField.rightView = imageView

        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: kDownIcon, style: .plain, target: self, action: #selector(closePicker))
        ]
        toolbar.sizeToFit()
        self.textField.inputAccessoryView = toolbar

        self.picker.dataSource = self
        self.picker.delegate = self

        self.textField.inputView = self.picker
    }

    // MARK: - Actions

    @IBAction func changeButtonTapped(_ sender: UIButton) {
        if self.textField.isFirstResponder {
            self.textField.resignFirstResponder()
            if let rightImageView = self.textField.rightView as? UIImageView {
                rightImageView.image = kDownIcon
            }
        }
        else {
            self.textField.becomeFirstResponder()

            if let rightImageView = self.textField.rightView as? UIImageView {
                rightImageView.image = kUpIcon
            }

            if let text = self.textField.text, text.isEmpty || self.textField.text == nil {
                self.textField.text = self.therapistTypeList.first?.title
            }
        }
    }

    @objc func closePicker() {
        self.endEditing(true)
    }
}

extension AuthorizationTextFieldButtonView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.therapistTypeList.count
    }
}

extension AuthorizationTextFieldButtonView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.therapistTypeList[row].title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let therapistType = self.therapistTypeList[row]
        self.textField.text = therapistType.title
        self.onChangeTherapistType?(therapistType)
    }
}
