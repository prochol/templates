//
// AuthorizationViewController.swift
// DaTracker
//
// Created by Pavel Kuzmin on 2018-12-03.
// Copyright © 2018 Gaika Group. All rights reserved.
//

import UIKit
import LocalAuthentication

private let kIsFirstStartVersion11Key = "isFirst11"

private let kTopGradientColor = UIColor.Palette.topGradientColor
private let kBottomGradientColor = UIColor.Palette.bottomGradientColor

/// The base class for cell display authorization
/// It should not be used as a final
class AuthorizationViewController: UIViewController {
    @IBOutlet internal weak var activityIndicator: UIActivityIndicatorView!

    internal let laContext = AuthorizationController.shared.laContext

    var completeAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [kTopGradientColor.cgColor, kBottomGradientColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradientLayer = self.view.layer.sublayers?.first
        gradientLayer?.frame = self.view.bounds
    }
}
