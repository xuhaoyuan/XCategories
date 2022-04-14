//
//  UIStackView+Circle.swift
//  CircleCommonUI
//
//  Created by 许浩渊 on 2020/4/21.
//  Copyright © 2020 MoreTech. All rights reserved.
//

import UIKit

extension UIStackView {

    convenience public init(subviews: [UIView] = [], axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) {
        self.init(arrangedSubviews: subviews)
        self.alignment = alignment
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
    }
}
