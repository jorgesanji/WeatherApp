//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Jorge Sanmartin on 22/03/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.backgroundColor = .lightGray
		self.window = window
	   
		let rootViewController: HomeViewController = .homeViewController()
	   
		window.rootViewController = rootViewController
		window.makeKeyAndVisible()
		
		return true
	}
}

extension UIApplication {
	
	public static var isRunningTest: Bool {
		return ProcessInfo().arguments.contains("testMode")
	}
}
