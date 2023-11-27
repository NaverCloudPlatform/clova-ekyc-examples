/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {

    open override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        switch viewControllers.last {
        case is VerifyIdCardDomainViewController:
            return false
        case is VerifyFaceDomainViewController:
            return false
        case is HomeViewController:
            return false
        case is eKYCCardFrontCheckViewController:
            return false
        case is eKYCCardTiltCheckViewController:
            return false
        case is eKYCCardBackCheckViewController:
            return false
        case is eKYCFaceCheckViewController:
            return false
        case is eKYCIcrCheckViewController:
            return false
        case is eKYCVerifyCheckViewController:
            return false
        case is eKYCDocumentFailViewController:
            return false
        default:
            return viewControllers.count > 1
        }
    }

    func push(
        viewController: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}
