//
//  Model.swift
//  RedFive
//
//  Created by Sean Crabtree on 11/4/15.
//  Copyright © 2015 Sean Crabtree. All rights reserved.
//

import Foundation
import UIKit

struct CFActive {   // ADD filter of data for only Running
	
	let name : String?
	let calls : String?
	let progress : String?  // JOHN - Calculate or Call?
	
	init(withJSON json : JSON) {
		name = json["name"].string
		calls = json["calls"].string
		progress = json["progress"].string
	}
}

struct CFInactive {   // ADD filter of data for only Done, Stopped, Scheduled
	
	let name : String?
	let calls : String?
	let progress : String?  // JOHN - Calculate or Call?
	
	init(withJSON json : JSON) {
		name = json["name"].string
		calls = json["calls"].string
		progress = json["progress"].string
	}
}

struct CFNumber {
	var name : String?  // TODO - Convert to (phone) num-bers format?
	var calls : String?
	var transfers : String?
	var missed : String?
	var texts : String?
}

struct CFKeyword {
	var name : String?
	var texts : String?
}

struct CFVoicemail {
	var name : String?
	var number : String?
	var received : String?
	var message: String?
	var length: String?
}

struct CFText {
	var name : String?
	var number : String?
	var received : String?
	var message: String?
}

