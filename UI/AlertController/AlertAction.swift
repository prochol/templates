//
// AlertAction.swift
// Flowwow
//
// Created by prochol on 11.02.2020.
// Copyright © 2020 Prochol. All rights reserved.
//

import Foundation

final class AlertAction {
    var title: String
    var style: AlertAction.Style
    var action: CompletionBlock?

    init(title: String, style: AlertAction.Style = AlertAction.Style.default, action: CompletionBlock?) {
        self.title = title
        self.style = style
        self.action = action
    }
}

extension AlertAction {
    public enum Style : Int {
        case `default`
        case transparent
    }
}

extension AlertAction.Style {
    var backgroundColor: UIColor {
        switch self {
        case .transparent:
            return UIColor.clear
        default:
            return "24B7A8".color!
        }
    }

    var borderColor: CGColor {
        switch self {
        case .transparent:
            return "F3F3F3".color!.cgColor
        default:
            return UIColor.clear.cgColor
        }
    }

    var titleColor: UIColor {
        switch self {
        case .transparent:
            return "484848".color!
        default:
            return UIColor.white
        }
    }
}
