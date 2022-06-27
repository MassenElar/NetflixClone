//
//  SceneDelegate.swift
//  NetflixClone
//
//  Created by developer on 6/6/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        if (Auth.auth().currentUser?.uid) != nil {
            let vc = MainTabBarViewController()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        } else {
            let nav = UINavigationController()
            let vc = EntryViewController()
            nav.viewControllers = [vc]
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        }
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = window else {
            return
        }
        window.rootViewController = vc
        
        UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
    
    func backToEntry(_ vc: UIViewController, animated: Bool = true) {
        guard let window = window else {
            return
        }
        let nav = UINavigationController()
        nav.viewControllers = [vc]
        window.rootViewController = nav
        UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

