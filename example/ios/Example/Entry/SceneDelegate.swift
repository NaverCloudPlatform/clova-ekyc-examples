/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: scene)
        let viewController = VerifyIdCardDomainViewController()
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
