//
// AlertController.swift
// Flowwow
//
// Created by prochol on 11.02.2020.
// Copyright © 2020 Prochol. All rights reserved.
//

import UIKit

final class AlertController: UIViewController {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var buttonsContainer: UIStackView!

    private var actionsContext: [UIButton: AlertAction] = [UIButton : AlertAction]()

    var message: String = String()
    var actions: [AlertAction] = defaultActions()

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = title
        messageLabel.text = message

        actions.forEach { action in
            let button = makeButton(by: action)
            actionsContext[button] = action
            buttonsContainer.addArrangedSubview(button)
        }
    }

    private func makeButton(by action: AlertAction) -> UIButton {
        let button = makeButton(by: action.style)
        button.setTitle(action.title, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }

    private func makeButton(by style: AlertAction.Style) -> UIButton {
        let button = UIButton.init(type: .system)
        button.backgroundColor = style.backgroundColor
        button.setTitleColor(style.titleColor, for: .normal)
        button.layer.cornerRadius = 4.0
        button.layer.borderColor = style.borderColor
        button.layer.borderWidth = 1.0

        return button
    }

    private class func defaultActions() -> [AlertAction] {
        return [
            AlertAction.init(title: "no".localized, style: .transparent, action: {}),
            AlertAction.init(title: "yes".localized, action: {})            
        ]
    }
}

extension AlertController {
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let action = actionsContext[sender] else { return }

        action.action?()
        dismiss(animated: true)
    }
}
