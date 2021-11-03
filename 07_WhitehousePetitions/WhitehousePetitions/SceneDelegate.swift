//
//  SceneDelegate.swift
//  WhitehousePetitions
//
//  Created by JC on 29/8/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        //We know that, for now, the root of our view controller is a TabBarController
        if let tabBarController = window?.rootViewController as? UITabBarController {
            //This finds the main Storyboard in our bundle (nil by default)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //Then we use the storyboard to instantiate the NavController
            let viewController = storyboard.instantiateViewController(withIdentifier: "NavController")
            //We attach a tab bar item to the nav controller using the topRated system item and giving it the ID (tag) 1
            viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
            //We add the view controller to the viewControllers array of the tabBarController
            tabBarController.viewControllers?.append(viewController)
        }
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

