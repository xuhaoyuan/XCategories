import Foundation

extension UIViewController {
    @discardableResult
    static func dismiss<T: UIViewController>(to targetVC: T.Type, animated: Bool, completion: ((UIViewController) -> Void)? = nil) -> Bool {
        guard let rootVC =  UIApplication.shared.keyWindow?.rootViewController else { return false }
        var next: UIViewController? = rootVC
        while next != nil {
            if let vc = next as? T, vc.presentedViewController != nil {
                vc.dismiss(animated: animated) {
                    completion?(vc)
                }
                return true
            }
            next = next?.presentedViewController
        }
        UIViewController.dismissAll(animated: animated, completion: nil)
        return true
    }
    
    static func dismissAll(animated: Bool, completion: VoidHandler?) {
        if let rootVC =  UIApplication.shared.keyWindow?.rootViewController {
            rootVC.dismiss(animated: animated, completion: {
                completion?()
            })
        }
    }
    
    @discardableResult
    func display(animated: Bool, onlyOne: Bool = false, completion: (() -> Void)? = nil) -> Bool {
        if let vc = currentTopViewController() {
            if onlyOne {
                if vc as? Self != nil {
                    return false
                }
            }
            vc.present(self, animated: animated, completion: {
                completion?()
            })
            return true
        }
        return false
    }
    
    func display<T: UIViewController>(from: T.Type, animated: Bool, completion: (() -> Void)? = nil) {
        if let rootVC =  UIApplication.shared.keyWindow?.rootViewController {
            var next: UIViewController? = rootVC
            repeat {
                if let vc = next as? T {
                    if let presented = vc.presentedViewController {
                        presented.dismiss(animated: false) {
                            vc.present(self, animated: animated) {
                                completion?()
                            }
                        }
                    } else {
                        vc.present(self, animated: animated) {
                            completion?()
                        }
                    }
                    return
                } else {
                    if next?.presentingViewController == nil {
                        next?.present(self, animated: animated, completion: {
                            completion?()
                        })
                    }
                    next = next?.presentingViewController
                }
            } while next != nil
        }
    }
    
    func dismissAll(animated: Bool, completion: VoidHandler?) {
        guard var pre = self.presentingViewController else {
            dismiss(animated: true, completion: completion)
            return
        }
        while pre.presentingViewController != nil {
            pre = pre.presentingViewController!
        }
        pre.dismiss(animated: true, completion: completion)
    }
}

func currentTopViewController() -> UIViewController? {
    guard let rootVC = UIApplication.shared.windows.first(where: {
        $0.tag == mainWindowTag
    })?.rootViewController else {
        return nil
    }
    return enumCurrentViewController(rootVC)
}

private func enumCurrentViewController(_ fromVC: UIViewController) -> UIViewController {
    if let fromVC = fromVC.presentedViewController {
        return enumCurrentViewController(fromVC)
    }
    if let fromVC = fromVC as? UINavigationController,
       fromVC.viewControllers.count > 0 {
        return enumCurrentViewController(fromVC.topViewController!)
    }
    if let fromVC = fromVC as? UITabBarController,
       (fromVC.viewControllers ?? []).count > 0 {
        return enumCurrentViewController(fromVC.selectedViewController!)
    }
    return fromVC
}
