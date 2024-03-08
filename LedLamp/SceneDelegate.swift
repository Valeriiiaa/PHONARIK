//
//  SceneDelegate.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 26.02.2024.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene
        let onboardingVC = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController()
        window?.rootViewController = onboardingVC!//UIHostingController(rootView: CustomTabBarView())
        self.window?.makeKeyAndVisible()
        
        guard !UserDefaults.standard.bool(forKey: "isNotFirstLaunch") else { return }
        UserDefaults.standard.set(true, forKey: "isNotFirstLaunch")
        
        LocationCollectionViewModel.allCases.forEach({ item in
            DatabaseManager.shared.save(RoomModel(name: item.titel, background: UIImage(resource: item.image).pngData(), lamps: "", status: false))
        })
    }
    
    func getConfiguredController() -> UITabBarController {
        //1- Initiate your viewControllers
        let tabBarItem = UITabBarItem(title: "light".localized, image: UIImage(resource: .lightTabBar), tag: 0)
        let firstViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        firstViewController.tabBarItem = tabBarItem
        
        let secondViewController = UIStoryboard(name: "Rooms", bundle: nil).instantiateInitialViewController()!
        secondViewController.tabBarItem = UITabBarItem(title: "rooms".localized, image: UIImage(resource: .roomsTabBar), tag: 1)
        let third = UIStoryboard(name: "MusicPlayer", bundle: nil).instantiateInitialViewController()!
        third.tabBarItem = UITabBarItem(title: "music".localized, image: UIImage(resource: .musicTabBar), tag: 2)
        //2- get instance of BEKCurveTabbarController
        let tabBarViewController = BEKCurveTabbarController.instantiate()
        
        //3- Config your own TabBar ViewModel
        let myViewModel = MyCustomTabBarViewModel()
        
        //4- setup TabBar Controller with you viewModel
        tabBarViewController.setupViewModel(viewModel: myViewModel)
        
        //5- set viewControllers to the tabbar
        tabBarViewController.setViewControllers([firstViewController, secondViewController, third], animated: true)
        (tabBarViewController.tabBar as? BEKCurveTabbar)?.addCircleShape()
        DispatchQueue.main.async {
            if let itemView = (tabBarItem.value(forKey: "view") as? UIView) {
                UIView.setAnimationsEnabled(false)
                UIView.performWithoutAnimation {
                    (tabBarViewController.tabBar as? BEKCurveTabbar)?.circleLayer?.position = itemView.frame.origin
                }
                
                UIView.setAnimationsEnabled(true)
            }
        }
        return tabBarViewController
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

