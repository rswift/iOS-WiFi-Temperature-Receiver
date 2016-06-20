//
//  ServerSingleton.swift
//  WiFiTemperatureReceiver
//
//  Created by Robert on 05/06/2016.
//  Copyright © 2016 vooey. All rights reserved.
//

//hat tip: http://krakendev.io/blog/the-right-way-to-write-a-singleton
class ServerSingleton {
	static let serverStatus = ServerSingleton()
	private init() {}

	var shouldSocketBeReset: Bool = true
	var isServerInstansiated: Bool = false
}