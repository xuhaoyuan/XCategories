import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UITableView {
    var showEmptyView: Binder<Bool> {
        return Binder(self.base) { tableView, show in
            show ? tableView.showEmptyView(style: .inWhiteBackground) : tableView.removeEmptyView()
        }
    }
    
    var showEmptyViewAdvanced: Binder<(Bool, String, EmptyDataViewStyle)> {
        return Binder(self.base) { tableView, info in
            info.0 ? tableView.showEmptyView(title: info.1, style: info.2) : tableView.removeEmptyView()
        }
    }
}
enum EmptyDataViewStyle {
    case inDarkBackground
    case inWhiteBackground
}
extension UITableView {
    private static let emptyViewTag = -1212
    func showEmptyView(title: String = "暂无数据", style: EmptyDataViewStyle) {
        removeEmptyView()
        let color: UIColor
        switch style {
        case .inWhiteBackground:
            color = .H_1C202C_40
        case .inDarkBackground:
            color = .H_FFFFFF_60
        }
        let emptyLabel = UILabel(text: title, font: .systemFont(ofSize: 12), color: color, alignment: .center)
        let emptyImage = UIImageView(image: R.image.iconEmptyData())
        emptyImage.translatesAutoresizingMaskIntoConstraints = false
        emptyImage.heightAnchor <> emptyImage.widthAnchor * (CGFloat(220) / CGFloat(360))
        let emptyStatck = UIStackView(subviews: [emptyImage, emptyLabel], axis: .vertical, alignment: .center, distribution: .fill, spacing: 20)
        emptyStatck.tag = Self.emptyViewTag
        addSubview(emptyStatck)
        emptyStatck <> [.centerX, .leading(20), .top(50)]
    }

    func removeEmptyView() {
        for view in subviews where view.tag == Self.emptyViewTag {
            view.removeFromSuperview()
        }
    }
}

public extension UITableView {

    func registerCell<T: UITableViewCell>(_: T.Type) {
        let identifier = String(describing: T.self)
        let filePath: String = (Bundle.main.resourcePath ?? "") + "/" + identifier + ".nib"
        if FileManager.default.fileExists(atPath: filePath) {
            register(UINib(nibName: identifier, bundle: .main), forCellReuseIdentifier: identifier)
        } else {
            register(T.self, forCellReuseIdentifier: identifier)
        }
    }

    func registerHeaderFooterClass<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
    }

    func dequeueReusableCell<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
        }
        return cell
    }

    func dequeueReusableCell<T: UITableViewCell>(_ indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
        }
        return cell
    }

    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not dequeue HeaderFooter with identifier: \(String(describing: T.self))")
        }
        return view
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
