//
//  AppDelegate.swift
//  WiFiTemperatureReceiver
//
//  Created by Robert on 04/05/2016.
//  Copyright © 2016 vooey. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	let status = ServerSingleton.serverStatus

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		return true
	}

	func applicationWillResignActive(application: UIApplication) { }

	func applicationDidEnterBackground(application: UIApplication) { }

	func applicationWillEnterForeground(application: UIApplication) { }

	func applicationDidBecomeActive(application: UIApplication) {
		// avoid any issues with the socket if the app is put in the background
		status.shouldSocketBeReset = true
	}

	func applicationWillTerminate(application: UIApplication) { }
}

