//
//  UStepgStateButton.swift
//  BubbleGame
//
//  Created by 许浩渊 on 2022/6/3.
//

import UIKit
import SnapKit

class XButton: UIView {

    enum State {
        case normal
        case selected
        case disable
        case loading
    }

    var titleEdge = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6) {
        didSet {
            titleLabel.snp.updateConstraints { make in
                make.leading.greaterThanOrEqualTo(titleEdge.left)
                make.trailing.lessThanOrEqualTo(-titleEdge.right)
                make.bottom.lessThanOrEqualTo(-titleEdge.bottom)
                make.center.equalToSuperview()
            }
        }
    }

    var state: State = .normal {
        didSet {
            updateState()
        }
    }

    var tapHandler: SingleHandler<XButton>?

    private(set) var titleLabel = UILabel()
    private var backView = UIView()
    private var loadingView = UIImageView()
    private var titleDic: [State: String] = [:]
    private var colorDic: [State: UIColor] = [:]
    private var titleColorDic: [State: UIColor] = [:]
    private var attributedTextDic: [State: NSAttributedString] = [:]

    private let iconSize: CGSize

    init(iconSize: CGSize = CGSize(width: 22, height: 22)) {
        self.iconSize = iconSize
        super.init(frame: .zero)

        addSubview(backView)
        addSubview(titleLabel)
        addSubview(loadingView)
        backView.isUserInteractionEnabled = false
        titleLabel.isUserInteractionEnabled = false
        loadingView.isUserInteractionEnabled = false

        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(titleEdge.top)
            make.leading.greaterThanOrEqualTo(titleEdge.left)
            make.trailing.lessThanOrEqualTo(-titleEdge.right)
            make.bottom.lessThanOrEqualTo(-titleEdge.bottom)
            make.center.equalToSuperview()
        }

        loadingView.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(titleLabel.snp.leading).offset(6)
        }

        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        addGestureRecognizer(tapGes)
    }

    @discardableResult
    func set(loadingImage: UIImage) -> Self {
        loadingView.image = loadingImage
        return self
    }

    @discardableResult
    func set(font: UIFont) -> Self {
        titleLabel.font = font
        return self
    }

    @discardableResult
    func set(textColor: UIColor, state: State) -> Self {
        titleColorDic[state] = textColor
        updateState()
        return self
    }

    @discardableResult
    func set(textColor: String, state: State) -> Self {
        titleColorDic[state] = UIColor(hex: textColor)
        updateState()
        return self
    }

    @discardableResult
    func set(title: String, state: State) -> Self {
        titleDic[state] = title
        updateState()
        return self
    }

    @discardableResult
    func set(attributedText: NSAttributedString, state: State) -> Self {
        attributedTextDic[state] = attributedText
        updateState()
        return self
    }

    @discardableResult
    func set(backColor: UIColor, state: State) -> Self {
        colorDic[state] = backColor
        updateState()
        return self
    }

    @discardableResult
    func set(backColor: String, state: State) -> Self {
        colorDic[state] = UIColor(hex: backColor)
        updateState()
        return self
    }

    @discardableResult
    func set(corner: CGFloat) -> Self {
        layer.cornerRadius = corner
        layer.masksToBounds = true
        return self
    }

    @objc private func tapGesture() {
        switch state {
        case .normal:
            tapHandler?(self)
        case .selected:
            tapHandler?(self)
        case .disable:
            break
        case .loading:
            break
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateState() {
        if let attr = attributedTextDic[state] {
            titleLabel.attributedText = attr
        } else if let title = titleDic[state] {
            titleLabel.text = title
        } else if let attr = attributedTextDic[.normal] {
            titleLabel.attributedText = attr
        } else {
            titleLabel.text = titleDic[.normal]
        }

        if let color = colorDic[state] {
            backView.layer.backgroundColor = color.cgColor
        } else {
            backView.layer.backgroundColor = colorDic[.normal]?.cgColor
        }

        if let color = titleColorDic[state] {
            titleLabel.textColor = color
        } else {
            titleLabel.textColor = titleColorDic[.normal]
        }

        if state == .loading {
            loadingView.isHidden = false
            loadingView.layer.add(getAnimation(), forKey: "animation")
        } else {
            loadingView.isHidden = true
            loadingView.layer.removeAllAnimations()
        }
    }

    private func getAnimation() -> CABasicAnimation {
        let rotation = CABasicAnimation.init(keyPath: "transform.rotation")
        rotation.toValue = CGFloat.pi*2
        rotation.duration = 0.125
        rotation.isRemovedOnCompletion = false
        rotation.fillMode = .forwards
        rotation.repeatCount = HUGE
        return rotation
    }
}
