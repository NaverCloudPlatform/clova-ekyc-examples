/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

extension UITableView {

    func register<T: UITableViewCell>(_ value: T.Type) {
        register(T.self, forCellReuseIdentifier: T.className)
    }

    func dequeueCell<T: UITableViewCell>(_ value: T.Type, for indexPath: IndexPath) -> T? {
        let cell = dequeueReusableCell(withIdentifier: T.className, for: indexPath)
        return cell as? T
    }
}

