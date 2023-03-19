//
//  SceneDelegate.swift
//  Notes
//
//  Created by Александр Харин on /163/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var appCoordinator = CoordinatorFactory().createAppFlowCoordinator(navigationController: UINavigationController())
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = appCoordinator.navigationController
        
        appCoordinator.start()
        
        window?.makeKeyAndVisible()
    }
    
    
}

