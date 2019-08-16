//
// TabBar.swift
// DaTracker
//
// Created by Pavel Kuzmin on 2018-12-03.
// Copyright © 2018 Gaika Group. All rights reserved.
//

import UIKit

private let kBarHeight: CGFloat = 56.0

private let kBorderColor = UIColor.init(r: 228, g: 228, b: 228)

class TabBar: UITabBar {
    private var borderLayer: CAShapeLayer = {
        let lineLayer = CAShapeLayer()
        lineLayer.fillColor = UIColor.white.cgColor
        lineLayer.strokeColor = kBorderColor.cgColor
        lineLayer.lineWidth = 1.0

        return lineLayer
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        self.items?.forEach {
            $0.imageInsets = UIEdgeInsets.init(top: 4.0, left: 0.0, bottom: -4.0, right: 0.0)
        }

        self.updateWave(by: 0)
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = kBarHeight

        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.keyWindow {
                let bottomPadding = window.safeAreaInsets.bottom
                sizeThatFits.height += bottomPadding
            }
        }

        return sizeThatFits
    }

    func updateWave(by selectedIndex: Int) {
        let bottomY = kBarHeight * 2

        let widthItem = UIScreen.main.bounds.width / 4
        let waveHeight: CGFloat = kBarHeight / 2 - 1
        let waveSize = CGSize.init(width: widthItem, height: waveHeight)

        let path = self.path(with: selectedIndex, size: waveSize, bottom: bottomY)
        self.borderLayer.path = path.cgPath

        self.borderLayer.removeFromSuperlayer()
        self.layer.insertSublayer(self.borderLayer, at: 0)
    }

    // MARK: - Private functions

    private func path(with index: Int, size waveSize: CGSize, bottom: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 1.0

        path.move(to: CGPoint.init(x: -0.1 * waveSize.width, y: 0.0))

        for angle in stride(from: 0.0, through: 360.0, by: 0.5) {
            let x = CGFloat(angle / 360.0) * (waveSize.width * 1.2) - CGFloat(0.0 / 360.0) * waveSize.width - 0.1 * waveSize.width + CGFloat(index) * waveSize.width

            let funcWave = (0.5 * sin(cos(angle / 360.0 * 2 * .pi + .pi))/sin(1)) + 0.5
            let y = -CGFloat(funcWave) * waveSize.height

            path.addLine(to: CGPoint.init(x: x, y: y))
        }

        path.addLine(to: CGPoint.init(x: UIScreen.main.bounds.width + 0.1 * waveSize.width, y: 0.0))
        path.addLine(to: CGPoint.init(x: UIScreen.main.bounds.width + 0.1 * waveSize.width, y: bottom))
        path.addLine(to: CGPoint.init(x: -0.1 * waveSize.width, y: bottom))

        return path
    }
}
