//
//  ViewController.swift
//  WiFiTemperatureReceiver
//

/*
 * This is a mindnumbingly simple application, linked directly to my version of the project
 * inspired by Roasthacker to capture and broadcast the bean mass temperature from my
 * Gene Café CBR-101 coffee roaster. The ultimate goal is to feed these temperatures into
 * the Roastmaster Data Logger for hands-free temperature capture directly on the iPad...
 *
 * The payload bring broadcast by the Adafruit board is formatted as JSON, the code here is
 * not well structured, but proves a point, so I've not abstracted anything away...
 *
 * It relies on SwiftSocket, which isn't the most fully featured or robut socket framework, but
 * it was quick to integrate, is simple, and worked without fuss... I'm not distributing SwiftSocket
 * but I just copied down the files from the ysocket directory
 *
 * This code is issued under the "Bill and Ted - be excellent to each other" licence (which
 * has no content, just, well, be excellent to each other), however, I have included the licence
 * files from my original starting file (serialthermocouple.ino) at the bottom of this sketch...
 *
 * I'm not a very experienced Xcode developer so I am quite sure I've made dozens of mistooks with
 * this, but it is a proof-of-concept, nothing more, so whilst I fully expect to be judged, I won't
 * take it personally :)
 *
 * This was built on iOS 9 in Xcode 7.3, works a treat.
 *
 * The JSON payload is simple, I posted to the Roastmaster Forum with my thoughts, I fully expect
 * far more development of the payload before it is actually useful. It is kept simple:
 *  - the probe name
 *  - the temperature in celsius
 *  - the temperature in farhenheit
 *  - optionally an array of debug data which isn't worth describing here so check the WiFiTemperatureBroadcast.ino file for details
 *
 * ToDo:
 *  - nothing really, this was a proof of concept, although there is a tremendous amount that could be improved
 *
 * Some links:
 *  - Broadcast app for ESP8266: https://github.com/rswift/wifi-temperature-broadcast/blob/master/WiFiTemperatureBroadcast.ino
 *  - Roasthacker: http://roasthacker.com/?p=529 & http://roasthacker.com/?p=552
 *  - SwiftSocket: https://github.com/swiftsocket/SwiftSocket
 *  - ysocket files I copied into Xcode: https://github.com/swiftsocket/SwiftSocket/tree/master/SwiftSocket/ysocket
 *  - Roastmaster forum: https://rainfroginc.com/frogpad/index.php?topic=154.0
 *
 * The icon is a hack of two icons downloaded from www.flaticon.com, the WiFi symbol was made by SimpleIcon and can
 * be found here http://www.flaticon.com/free-icon/wifi-medium-signal-symbol_34143 and the thermometer icon was made by
 * Freepik and can be found here http://www.flaticon.com/free-icon/thermometer-2svg_124971 both icons are used under the
 * Creative Commons BY 3.0 licence which can be found here https://creativecommons.org/licenses/by/3.0/ and obviously if
 * anyone wants to develop this work further, please ensure the original creators are linked, otherwise, not cool...
 *
 *  Robert Swift - June 2016.
 */

import UIKit
import CoreFoundation

typealias Payload = [String: AnyObject]

class ViewController: UIViewController, UITableViewDelegate {

	let udpPortToListenOn: Int = 31855
	let status = ServerSingleton.serverStatus
	@IBOutlet var portLabel: UILabel!
	var temperaturesReceived: Array<String> = []

	@IBOutlet var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(animated: Bool) {
		portLabel.text = "Port: \(udpPortToListenOn)"
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
			//turn the server to broadcast mode with the address 255.255.255.255 or empty string
			var run: Bool = true

			// initialise once
			var server: UDPServer = UDPServer.init(addr: "", port: self.udpPortToListenOn) //UDPServer(addr:"", port: self.udpPortToListenOn)
			self.status.shouldSocketBeReset = false
			self.status.isServerInstansiated = true
			while run {
				if (!server.isConnected() || self.status.shouldSocketBeReset || !self.status.isServerInstansiated) {
					server.close() // just in case
					server = UDPServer(addr:"", port: self.udpPortToListenOn)
					self.status.shouldSocketBeReset = false
					self.status.isServerInstansiated = true
				}
				let (socketData, remoteIp, remotePort) = server.recv(1024) // 1024 based on example, trim?
				if let dataReceived = socketData {
					if let str = String(bytes: dataReceived, encoding: NSUTF8StringEncoding) {
						let probeData = str.parseBroadcastTemperatureData
							self.temperaturesReceived.insert("\(String(format: "%.2f", (probeData?.celsius)!))℃ at \(Time().HHMMSS) from \(remoteIp):\(remotePort)", atIndex: 0)
							// http://stackoverflow.com/a/26744884
							dispatch_async(dispatch_get_main_queue()) {
								self.tableView.reloadData()
							}
						} else {
							run = false
						}
					} // if let dataReceived...
			} // while
			server.close()
		})
	}
 
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK - Table Delegate methods
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return temperaturesReceived.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "TemperatureCell")
		cell.textLabel?.text = String(temperaturesReceived[indexPath.row])
		return cell
	}
}

/*	what GCN would described a proper bodge...
	but it keeps things in a single file so easy to read for the purposes of proving a concept */
extension String {
	var parseBroadcastTemperatureData: (celsius: Float, farenheit: Float, probeName: String)? {
		let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
		
		if let jsonData = data {
			// Will return an object or nil if JSON decoding fails
			do {
				let message = try NSJSONSerialization.JSONObjectWithData(jsonData, options:.MutableContainers)

				// looking for celsius, farenheit, probeName and debugData (which, if present has sub elements)
				if let json = message as? NSMutableDictionary {
					let celsius: Float = (json.valueForKey("celsius") as? Float)!
					let fahrenheit: Float = (json.valueForKey("fahrenheit") as? Float)!
					let probeName: String = (json.valueForKey("probeName") as? String)!
					if (json.valueForKey("debugData") != nil) {
						// if debugging is set on the probe side, why not render some useful data this side too?
						print("celsius=\(celsius) fahrenheit=\(fahrenheit) probeName=\(probeName)")
						for (k, v) in (json.valueForKey("debugData") as? NSDictionary)! {
							print("debugData: \(k)=\(v)")
						}
					}
					return (celsius, fahrenheit, probeName)
				}
			}
			catch let error as NSError {
				print("An error occurred: \(error)")
				return nil
			}
		}
		return nil // Lossless conversion of the string was not possible
	}
}

typealias Time = NSDate
extension NSDate {
	var HHMMSS: String {
		let timeFormatter = NSDateFormatter()
		timeFormatter.dateFormat = "HH:mm:ss"
		let timeString = timeFormatter.stringFromDate(self)
		return timeString
	}
}

/*
 * basic function added by me to determine if the connection is valid
 * putting this here means unmodified ysocket download works fine
 */
extension UDPServer {
	public func isConnected() -> Bool {
		if (self.fd != nil && self.fd! > 0 && fcntl(self.fd!, F_GETFD) != -1) {
			return true
		}
		return false
	}
}