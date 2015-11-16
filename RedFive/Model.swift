//
//  Model.swift
//  RedFive
//
//  Created by Sean Crabtree on 11/4/15.
//  Copyright © 2015 Sean Crabtree. All rights reserved.
//

import Foundation
import UIKit

struct Active {   // ADD filter of data for only Running
	
	let name : String?
	let calls : String?
	let progress : String?  // JOHN - Calculate or Call?
	
	init(withJSON json : JSON) {
		name = json["name"].string
		calls = json["calls"].string
		progress = json["progress"].string
	}
}

struct Inactive {   // ADD filter of data for only Done, Stopped, Scheduled
	
	let name : String?
	let calls : String?
	let progress : String?  // JOHN - Calculate or Call?
	
	init(withJSON json : JSON) {
		name = json["name"].string
		calls = json["calls"].string
		progress = json["progress"].string
	}
}

struct Numbers {
	
	let name : String?  // JOHN - Convert to (phone) num-bers format?
	let calls : String?
	let transfers : String?
	let missed : String?
	let texts : String?
	
	init(withJSON json : JSON) {
		name = json["name"].string
		calls = json["calls"].string
		transfers = json["transfers"].string
		missed = json["missed"].string
		texts = json["texts"].string
	}
}

struct Keywords {
	
	let name : String?
	let texts : String?
	
	init(withJSON json : JSON) {
		name = json["name"].string
		texts = json["texts"].string
	}
}

struct Voicemails {
	
	let name : String?
	let number : String?
	let received : String?
	
	init(withJSON json : JSON) {
		name = json["name"].string
		number = json["number"].string
		received = json["received"].string
	}
}

struct Texts {
	
	let name : String?
	let number : String?
	let received : String?
	
	init(withJSON json : JSON) {
		name = json["name"].string
		number = json["number"].string
		received = json["received"].string
	}
}

