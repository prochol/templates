//
//  NibView.swift
//
//
//  Created by Pavel Kuzmin on 06.08.2020.
//  Copyright © 2020 prochol. All rights reserved.
//

import UIKit

open class NibView: UIView {
    @IBOutlet public weak var contentView: UIView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        attachNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        attachNib()
    }
    
    private func attachNib() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed(nameOfClass, owner: self, options: nil)
        
        addSubview(contentView)
        
        addConstraints(forView: contentView)
    }
    
    private func addConstraints(forView view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
