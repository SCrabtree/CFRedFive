//
//  CallFire.swift
//  RedFive
//
//  Created by John Piersol on 11/16/15.
//  Copyright © 2015 Sean Crabtree. All rights reserved.
//

import Foundation
import Alamofire

class CallFire {
    let rootUrlV1_1 = "https://www.callfire.com/"
    let rootUrlV2 = "https://www.callfire.com/v2"
    let textLimit = 10
    let voiceLimit = 10
    let numberLimit = 10
    let keywordLimit = 10
	let activeLimit = 10
	let inactiveLimit = 10
	
    // TODO Remove these default credentials
    var credential = NSURLCredential(user: "42054e0ab7f2", password: "ce82c68b20685a90", persistence: .ForSession)
    
    func setCredential(user: String, password: String) {
        setCredential(NSURLCredential(user: user, password: password, persistence: .ForSession))
    }
    
    func setCredential(credential: NSURLCredential) {
        self.credential = credential
    }
	
	//TEXT MESSAGES
    func getTexts(callback: ((cfTexts: [CFText]) -> Void)?) {
        Alamofire.request(.GET, rootUrlV2 + "/texts", parameters: ["limit": textLimit])
                .authenticate(usingCredential: credential)
                .validate()
                .responseJSON { response in
                    var texts:[CFText] = []
                    if let value = response.result.value as? NSDictionary {
                        if let items = value["items"] as? NSArray {
                            for item in items {
                                //let textJSON = JSON(["name":"(123) 456-7890","number":"(818) 555-1234","received":"7/06/13  4:32 PM"])
                                let json = JSON(item)
                                var text = CFText()
                                let inbound = json["inbound"].boolValue
                                // TODO name probably should be contact name
                                text.name = self.formatNumber(inbound ? json["fromNumber"].string : json["toNumber"].string)
                                text.number = self.formatNumber(inbound ? json["toNumber"].string : json["fromNumber"].string)
                                // TODO convert 'created' long unixtime to formatted date
                                //let received = NSDate(timeIntervalSince1970: json["created"].doubleValue)
                                text.received = json["created"].string
                                text.message = json["message"].string
                                texts.append(text)
                            }
                        }
                    }
                    callback?(cfTexts: texts)
                }
    }
	
	// VOICEMAIL MESSAGES
	func getVoicemails(callback: ((cfVoicemails: [CFVoicemail]) -> Void)?) {
        Alamofire.request(.GET, rootUrlV2 + "/calls", parameters: ["limit": voiceLimit])
            .authenticate(usingCredential: credential)
            .validate()
            .responseJSON { response in
                var voicemails:[CFVoicemail] = []
                if let value = response.result.value as? NSDictionary {
                    if let items = value["items"] as? NSArray {
                        for item in items {
                            //let voicemailJSON = JSON(["name":"(212) 555-1234","number":"(310) 555-1234","received":"10/30/15  10:12 PM"])
                            let json = JSON(item)
                            //print("# call: \(json)")
                            var voicemail = CFVoicemail()
                            let inbound = json["inbound"].boolValue
                            // TODO name probable should be contact name
                            voicemail.name = self.formatNumber(inbound ? json["fromNumber"].string : json["toNumber"].string)
                            voicemail.number = self.formatNumber(inbound ? json["toNumber"].string : json["fromNumber"].string)
                            // TODO convert 'created' long unixtime to formatted date
                            //let received = NSDate(timeIntervalSince1970: json["created"].doubleValue)
                            voicemail.received = json["created"].string
                            // TODO Determine what 'message' means
                            voicemail.message = "unknown"
                            voicemail.length = "5"
                            voicemails.append(voicemail)
                        }
                    }
                }
                callback?(cfVoicemails: voicemails)
        }
	}
	
	// NUMBERS DASHBOARD
    func getNumbers(callback: ((cfNumbers: [CFNumber]) -> Void)?) {
        Alamofire.request(.GET, rootUrlV2 + "/numbers/leases", parameters: ["limit": numberLimit])
            .authenticate(usingCredential: credential)
            .validate()
            .responseJSON { response in
                var numbers:[CFNumber] = []
                if let value = response.result.value as? NSDictionary {
                    if let items = value["items"] as? NSArray {
                        for item in items {
                            //let numbersJSON = JSON(["name":"(310) 555-1234","calls":"100","transfers":"60","missed":"40","texts":"50"])
                            let json = JSON(item)
                            //print("# number: \(json)")
                            var number = CFNumber()
                            // TODO find data for number or add attributes like 'status', 'leaseEnd', etc...
                            number.name = json["nationalFormat"].string
                            number.calls = "*100"
                            number.transfers = "*60"
                            number.missed = "*40"
                            number.texts = "*50"
                            numbers.append(number)
                        }
                    }
                }
                callback?(cfNumbers: numbers)
        }
    }
	
	// ACTIVE DASHBOARD	-- NEW
	func getActive(callback: ((cfActives: [CFActive]) -> Void)?) {
		Alamofire.request(.GET, rootUrlV2 + "/campaigns/voice-broadcasts?running", parameters: ["limit": activeLimit])
			.authenticate(usingCredential: credential)
			.validate()
			.responseJSON { response in
				var actives:[CFActive] = []
				if let value = response.result.value as? NSDictionary {
					if let items = value["items"] as? NSArray {
						for item in items {
							//let activeJSON = JSON(["name":"Active Broadcast","calls":"42","progress":"24%"])
							let json = JSON(item)
							//print("# active: \(json)")
							var active = CFActive()
							// TODO
							active.name = json["API Active Broadcast"].string
							active.calls = "*42"
							active.progress = "*24%"
							actives.append(active)
						}
					}
				}
				callback?(cfActives: actives)
		}
	}
	
	
	// INACTIVE DASHBOARD	-- NEW
	func getInactive(callback: ((cfInactives: [CFInactive]) -> Void)?) {
		Alamofire.request(.GET, rootUrlV2 + "/campaigns/voice-broadcasts", parameters: ["limit": activeLimit])
			.authenticate(usingCredential: credential)
			.validate()
			.responseJSON { response in
				var inactives:[CFInactive] = []
				if let value = response.result.value as? NSDictionary {
					if let items = value["items"] as? NSArray {
						for item in items {
							//let inactiveJSON = JSON(["name":"Inactive Broadcast","calls":"108","progress":"100%"])
							let json = JSON(item)
							//print("# inactive: \(json)")
							var inactive = CFInactive()
							// TODO
							inactive.name = json["API Inactive Broadcast"].string
							inactive.calls = "*108"
							inactive.progress = "*100%"
							inactives.append(inactive)
						}
					}
				}
				callback?(cfInactives: inactives)
		}
	}


//	ACTIVE DASHBOARD By Piersol
//	func getActive(callback: ((cfActives: [CFActive]) -> Void)?) {
//		let activeJSON = JSON(["name":"Active Broadcast","calls":"42","progress":"24%"])
//		let activeData = CFActive(withJSON: activeJSON)
//		var actives: [CFActive] = []
//		actives.append(activeData)
//		
//		callback?(cfActives: actives)
//	}
	
//	INACTIVE DASHBOARD By Piersol
//	func getInactive(callback: ((cfInactives: [CFInactive]) -> Void)?) {
//		let inactiveJSON = JSON(["name":"Inactive Broadcast","calls":"108","progress":"100%"])
//		let inactiveData = CFInactive(withJSON: inactiveJSON)
//		var inactives: [CFInactive] = []
//		inactives.append(inactiveData)
//		
//        callback?(cfInactives: inactives)
//	}
	
	// KEYWORDS DASHBOARD
	func getKeywords(callback: ((cfKeywords: [CFKeyword]) -> Void)?) {
        Alamofire.request(.GET, rootUrlV2 + "/keywords/leases", parameters: ["limit": keywordLimit])
            .authenticate(usingCredential: credential)
            .validate()
            .responseJSON { response in
                var keywords:[CFKeyword] = []
                if let value = response.result.value as? NSDictionary {
                    if let items = value["items"] as? NSArray {
                        for item in items {
                            //let keywordsJSON = JSON(["name":"TEST","texts":"20"])
                            let json = JSON(item)
                            var keyword = CFKeyword()
                            // TODO find data for number or add attributes like 'status', 'leaseEnd', etc...
                            keyword.name = json["keyword"].string
                            keyword.texts = "*20"
                            keywords.append(keyword)
                        }
                    }
                }
                callback?(cfKeywords: keywords)
        }
	}

    // TODO Implement
    func formatNumber(number: String?) -> String? {
        return number
    }
}