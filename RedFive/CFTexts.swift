//
//  CFTexts.swift
//  RedFive
//
//  Created by Sean Crabtree on 11/4/15.
//  Copyright © 2015 Sean Crabtree. All rights reserved.
//

import Foundation
import UIKit

protocol APIDelegate {
	func gotData(items : [JSON])
}

class CFApiTexts {
	
	var delegate : APIDelegate?
	
	func getCFTexts(endPoint:String) {
		
		let textsEndpoint: String = "https://api.callfire.com/v2\(endPoint)"// /numbers/leases /texts, /calls, etc.
		let session = NSURLSession.sharedSession()
		let url = NSURL(string: textsEndpoint)!
		let username = "42054e0ab7f2"
		let password = "ce82c68b20685a90"
		let loginString = NSString(format: "%@:%@", username, password)
		let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
		let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
		let request = NSMutableURLRequest(URL: url)
		request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
		request.HTTPMethod = "GET"
		
		let task = session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
			// Make sure we get an OK response
			guard let realResponse = response as? NSHTTPURLResponse where
				realResponse.statusCode == 200 else {
					print("Not a 200 response")
					return
			}
			
			// Read the JSON
			do {
				if let apiDataAsString = NSString(data:data!, encoding: NSUTF8StringEncoding) {
					
					// Print data as String
					print(apiDataAsString)
					
					// Parsed via SwiftyJSON
					let json = JSON.init(data: data!)
					if let items = json["items"].array {
						dispatch_async(dispatch_get_main_queue()) {
							self.delegate?.gotData(items)
						}
					}
					
					// Parse the JSON to get the IP
					//					let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
					//					print(jsonDictionary)
					//
					//					if let origin = jsonDictionary["items"] as? NSArray {
					//					}
					
					// Update the label
					//                    self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
				}
			} catch {
				print("bad things happened")
			}
		})
		
		// execute
		task.resume()
	}
	
	// SWIFTY JSON CONVERSION
	//
	//	let smsData = getTexts(CallFire)
	//	let data = smsData["items"].stringValue
	//	print("\(data)")
	
}


