//
//  MessagesTVC.swift
//  RedFive
//
//  Created by Sean Crabtree on 11/4/15.
//  Copyright © 2015 Sean Crabtree. All rights reserved.
//

import UIKit
import Alamofire

class VoicemailCell: UITableViewCell {
	
	@IBOutlet weak var voicemailName: UILabel!
	@IBOutlet weak var voicemailNumber: UILabel!
	@IBOutlet weak var voicemailReceived: UILabel!
	
	var voicemails : CFVoicemail? {
		didSet {
			if voicemails != nil {
				voicemailName.text = voicemails?.name
				voicemailNumber.text = voicemails?.number
				voicemailReceived.text = voicemails?.received
			}
		}
	}
}

class TextCell: UITableViewCell {
	
	@IBOutlet weak var textName: UILabel!
	@IBOutlet weak var textNumber: UILabel!
	@IBOutlet weak var textReceived: UILabel!
	
	var texts : CFText? {
		didSet {
			if texts != nil {
				textName.text = texts?.name
				textNumber.text = texts?.number
				textReceived.text = texts?.received
			}
		}
	}
//	AUTO-SIZING TEXT MESSAGE CELLS: See project MOBChat has “auto sizing cells”. Three key things…
//
//	1) Add this to viewDidLoad so that your table view knows it can resize cells:
//	tableView?.rowHeight = UITableViewAutomaticDimension
//	tableView?.estimatedRowHeight = 44
//	Note: The estimatedRowHeight should be the “average” height you expect the cell to be. 44 points is default.
//	
//	2) In the storyboard, make sure you have top-to-bottom constraints for your views, but don’t give the UILabel a fixed height (let it use intrinsic height).
//	
//	3) Set the numberOfLines property on the UILabel to 0 (it defaults to 1) - under the attributes inspector.
}

	// MARK: - Table View Controller

class MessagesTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var voicemails = [CFVoicemail]()
	var texts = [CFText]()
	
	var segmentCellIdentifier = "VoicemailCell"
	var callfire = CallFire();
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	@IBAction func segmentedControlChanged(sender: UISegmentedControl) {
		
		if segmentedControl.selectedSegmentIndex == 0 {
			segmentCellIdentifier = "VoicemailCell"
		} else if segmentedControl.selectedSegmentIndex == 1 {
			segmentCellIdentifier = "TextCell"
		}
		
		tableView.reloadData()
	}
	@IBAction func reloadHit(sender: UIBarButtonItem) {
		tableView.reloadData()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        callfire.getTexts(handleCFTexts)
        callfire.getVoicemails(handleCFVoicemails)
		
		UINavigationBar.appearance().translucent = false
		UINavigationBar.appearance().barTintColor = UIColor(colorLiteralRed: 0, green: 45, blue: 69, alpha: 1)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Table view data source
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if segmentedControl.selectedSegmentIndex == 0 {
			return voicemails.count + 1
		}
		return texts.count + 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier(segmentCellIdentifier, forIndexPath: indexPath) as UITableViewCell
		
		if indexPath.row == 0 {
			return cell
		}
		
		if segmentedControl.selectedSegmentIndex == 0 {
			(cell as! VoicemailCell).voicemails = voicemails[indexPath.row - 1]
		} else if segmentedControl.selectedSegmentIndex == 1 {
			(cell as! TextCell).texts = texts[indexPath.row - 1]
		}
		return cell
	}
	
	// MARK: - Navigation
	
	//    // In a storyboard-based application, you will often want to do a little preparation before navigation
	//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	//        // Get the new view controller using segue.destinationViewController.
	//        // Pass the selected object to the new view controller.
	//    }
    
    func handleCFTexts(cfTexts: [CFText]) {
        print("# MessageTVC.handleCFTexts")
        texts += cfTexts
        
        tableView.reloadData()
    }
    
    func handleCFVoicemails(cfVoicemails: [CFVoicemail]) {
        print("# MessageTVC.handleCFVoicemails")
        voicemails += cfVoicemails
        
        tableView.reloadData()
    }
    
//    func updateTextsAndCalls() {
//        
//        // STUB DATA
//        //		let voicemailJSON = JSON(["name":"(212) 555-1234","number":"(310) 555-1234","received":"10/30/15  10:12 PM"])
//        //		let voicemailData = Voicemails(withJSON: voicemailJSON)
//        //		voicemails.append(voicemailData)
//        voicemails += callfire.getVoicemails()
//        
//        //		let textJSON = JSON(["name":"(123) 456-7890","number":"(818) 555-1234","received":"7/06/13  4:32 PM"])
//        //		let textData = CFApiTexts(withJSON: textJSON)
//        //		texts.append(textData)
//        texts += callfire.getTexts()
//        
//        tableView.reloadData()
//        //        print("### CallFire alamoTest3")
//        //        let user = "42054e0ab7f2"
//        //        let password = "ce82c68b20685a90"
//        //        let credential = NSURLCredential(user: user, password: password, persistence: .ForSession)
//        //
//        //        let request = Alamofire.request(.GET, "https://www.callfire.com/v2/texts", parameters: ["limit": "2"])
//        //        .authenticate(usingCredential: credential)
//        //        .validate()
//        //        .responseJSON { response in
//        //            //			print("### request")
//        //            //			print(response.request)  // original URL request
//        //            //			print("### response")
//        //            //			print(response.response) // URL response
//        //            //			print("### data")
//        //            //			print(response.data)     // server data
//        //            //			print("### result")
//        //            //			print(response.result)   // result of response serialization
//        //
//        //            if let json = response.result.value as? Dictionary<String {
//        //                print("json: \(json)")
//        //                //print("items: \(json[]))
//        //            }
//
//    }
}

