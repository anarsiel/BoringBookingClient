//
//  SceneDelegate.swift
//  BoringBookingClient
//
//  Created by Blagoi on 25.11.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var controller: RestaurantsViewController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let mainScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: mainScene)
        window?.rootViewController = LoginViewController()
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
    }
}

