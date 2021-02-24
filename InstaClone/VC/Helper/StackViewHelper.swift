//
//  StackViewHelper.swift
//  InstaClone
//
//  Created by phat on 24/02/2021.
//

import Foundation
import UIKit

class StackView: UIStackView {
    init(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution = .fill , views: [UIView]) {
        super.init(frame: .zero)
        self.axis = axis
        self.distribution = self.distribution
        for index in (0...views.count).reversed() {
            self.addArrangedSubview(views[index])
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VStackView: StackView {
    init(distribution: UIStackView.Distribution = .fill, _ views: UIView...) {
        super.init(axis: .vertical, distribution: distribution, views: views)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class HStackView: StackView {
    init(distribution: UIStackView.Distribution = .fill, _ views: UIView...) {
        super.init(axis: .horizontal, distribution: distribution, views: views)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
