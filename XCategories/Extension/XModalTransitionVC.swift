//
//  BaseModalTransitionVC.swift
//  BubbleGame
//
//  Created by 许浩渊 on 2022/6/3.
//

import UIKit

public protocol TransitionCoordinator: UIViewController {
    func presentAnimation()
    func presentCompletion()
    func dismissAnimation()
    func dismissCompletion()
    func backgroundTapHandler()
    func backgroundIsUserEnable() -> Bool
    func backgroundConfig(view: inout UIControl)
}

extension TransitionCoordinator {
    func backgroundIsUserEnable() -> Bool { true }

    func backgroundConfig(view: inout UIControl) {}

    func backgroundTapHandler() {
        dismiss(animated: true)
    }

    func presentCompletion() {}

    func dismissCompletion() {}
}

open class XModalTransitionVC: UIViewController {

    private var coordinator: TransitionCoordinator? {
        guard self is TransitionCoordinator else { return nil }
        return self as? TransitionCoordinator
    }

    private lazy var backgroundView: UIControl = {
        var view = UIControl()
        coordinator?.backgroundConfig(view: &view)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.addTarget(self, action: #selector(backgroundTap), for: .touchUpInside)
        return view
    }()

    public init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    @available(*, unavailable)
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }

    private func configUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard isBeingPresented else { return }
        view.layoutIfNeeded()
        transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.coordinator?.presentAnimation()
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.coordinator?.presentCompletion()
        })
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard isBeingDismissed else { return }
        transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.coordinator?.dismissAnimation()
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.coordinator?.dismissCompletion()
        })
    }

    @objc private func backgroundTap() {
        guard let c = coordinator, c.backgroundIsUserEnable() else { return }
        coordinator?.backgroundTapHandler()
    }
}
