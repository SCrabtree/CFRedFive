//
//  File1.swift
//  RedFive
//
//  Created by Sean Crabtree on 11/12/15.
//  Copyright © 2015 Sean Crabtree. All rights reserved.
//

import Foundation
import Alamofire

//protocol APIManagerDelegate {
//	func gotData(items:[JSON])
//}

class APIManager : APIDelegate {
	
//	var delegate : APIManagerDelegate?
	var api = CFApiTexts()
	var handler : (([JSON]) -> ())?
	
	func getData(endPoint:String, handler:([JSON])->()) {
		api.delegate = self
		api.getCFTexts(endPoint)
		self.handler = handler
	}
	
	func gotData(items: [JSON]) {
		handler?(items)
//		delegate?.gotData(items)
		print(items[0])
	}
}
