//
//  CallFire.swift
//  RedFive
//
//  Created by John Piersol on 11/16/15.
//  Copyright © 2015 Sean Crabtree. All rights reserved.
//

import Foundation

class CallFire {
    
	func getTexts() -> [CFText] {
		let textJSON = JSON(["name":"(123) 456-7890","number":"(818) 555-1234","received":"7/06/13  4:32 PM"])
		let textData = CFText(withJSON: textJSON)
		var texts:[CFText] = []
		texts.append(textData)
		return texts
	}

	func getVoicemails() -> [CFVoicemail] {
		let voicemailJSON = JSON(["name":"(212) 555-1234","number":"(310) 555-1234","received":"10/30/15  10:12 PM"])
		let voicemailData = CFVoicemail(withJSON: voicemailJSON)
		var voicemails:[CFVoicemail] = []
		voicemails.append(voicemailData)
		return voicemails
	}
	
    func getNumbers() -> [CFNumber] {
		let numbersJSON = JSON(["name":"(310) 555-1234","calls":"100","transfers":"60","missed":"40","texts":"50"])
		let numbersData = CFNumber(withJSON: numbersJSON)
		var numbers:[CFNumber] = []
		numbers.append(numbersData)
		return numbers
    }
	
	func getActive() -> [CFActive] {
		let activeJSON = JSON(["name":"Active Broadcast","calls":"42","progress":"24%"])
		let activeData = CFActive(withJSON: activeJSON)
		var active:[CFActive] = []
		active.append(activeData)
		return active
	}
	
	func getInactive() -> [CFInactive] {
		let inactiveJSON = JSON(["name":"Inactive Broadcast","calls":"108","progress":"100%"])
		let inactiveData = CFInactive(withJSON: inactiveJSON)
		var inactive:[CFInactive] = []
		inactive.append(inactiveData)
		return inactive
	}
	
	func getKeywords() -> [CFKeyword] {
		let keywordsJSON = JSON(["name":"TEST","texts":"20"])
		let keywordsData = CFKeyword(withJSON: keywordsJSON)
		var keywords:[CFKeyword] = []
		keywords.append(keywordsData)
		return keywords
	}


}