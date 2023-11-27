/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

extension UIViewController {

    func pushIfAvailable(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        if navigationController?.visibleViewController == self {
            navigationController?.push(viewController: viewController, animated: animated, completion: completion)
        }
    }
}
