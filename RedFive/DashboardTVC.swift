//
//  DashboardTVC.swift
//  RedFive
//
//  Created by Sean Crabtree on 11/4/15.
//  Copyright © 2015 Sean Crabtree. All rights reserved.
//

import UIKit
 
// MARK: - Table View Cells

class ActiveCell: UITableViewCell {
	@IBOutlet weak var activeName: UILabel!
	@IBOutlet weak var activeCalls: UILabel!
	@IBOutlet weak var activeProgress: UILabel!

	var active : CFActive? {
		didSet {
			if active != nil {
				activeName.text = active?.name
				activeCalls.text = active?.calls
				activeProgress.text = active?.progress
			}
		}
	}
}
class InactiveCell: UITableViewCell {
	@IBOutlet weak var inactiveName: UILabel!
	@IBOutlet weak var inactiveCalls: UILabel!
	@IBOutlet weak var inactiveProgress: UILabel!
	
	var inactive : CFInactive? {
		didSet {
			if inactive != nil {
				inactiveName.text = inactive?.name
				inactiveCalls.text = inactive?.calls
				inactiveProgress.text = inactive?.progress
			}
		}
	}
}
class NumbersCell: UITableViewCell {
	@IBOutlet weak var numbersName: UILabel!
	@IBOutlet weak var numbersCalls: UILabel!
	@IBOutlet weak var numbersTransfers: UILabel!
	@IBOutlet weak var numbersMissed: UILabel!
	@IBOutlet weak var numbersTexts: UILabel!
	
	var numbers : CFNumber? {
		didSet {
			if numbers != nil {
				numbersName.text = numbers?.name
				numbersCalls.text = numbers?.calls
				numbersTransfers.text = numbers?.transfers
				numbersMissed.text = numbers?.missed
				numbersTexts.text = numbers?.texts
			}
		}
	}
}
class KeywordsCell: UITableViewCell {
	@IBOutlet weak var keywordsName: UILabel!
	@IBOutlet weak var keywordsTexts: UILabel!
	
	var keywords : CFKeyword? {
		didSet {
			if keywords != nil {
				keywordsName.text = keywords?.name
				keywordsTexts.text = keywords?.texts
			}
		}
	}
}

// MARK: - Table View Controller

class DashboardTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var actives = [CFActive]()
	var inactives = [CFInactive]()
	var numbers = [CFNumber]()
	var keywords = [CFKeyword]()
	
	var segmentCellIdentifier = "ActiveCell"
    var callfire = CallFire();
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	@IBAction func segmentedControlChanged(sender: UISegmentedControl) {

		if segmentedControl.selectedSegmentIndex == 0 {
			segmentCellIdentifier = "ActiveCell"
		} else if segmentedControl.selectedSegmentIndex == 1 {
			segmentCellIdentifier = "InactiveCell"
		} else if segmentedControl.selectedSegmentIndex == 2 {
			segmentCellIdentifier = "NumbersCell"
		} else if segmentedControl.selectedSegmentIndex == 3 {
			segmentCellIdentifier = "KeywordsCell"
		}
		
		tableView.reloadData()
	}
	@IBAction func reloadHit(sender: UIBarButtonItem) {
		tableView.reloadData()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callfire.getActive(handleCFActives)
        callfire.getInactive(handleCFInactives)
        callfire.getNumbers(handleCFNumbers)
        callfire.getKeywords(handleCFKeywords)

		UINavigationBar.appearance().translucent = false
		UINavigationBar.appearance().barTintColor = UIColor(red: 0, green: 45/255, blue: 89/255, alpha: 1)
		
//		let manager = APIManager()
//		manager.getData("/numbers/leases", handler: {items in
//			self.gotData(items,type:"leases")
//		})
//
//		tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    func handleCFActives(cfActives: [CFActive]) {
        print("# MessageTVC.handleCFActives")
        actives += cfActives
        tableView.reloadData()
    }
    
    func handleCFInactives(cfInactives: [CFInactive]) {
        print("# MessageTVC.handleCFInactives")
        inactives += cfInactives
        tableView.reloadData()
    }
    
    func handleCFNumbers(cfNumbers: [CFNumber]) {
        print("# MessageTVC.handleCFNumbers")
        numbers += cfNumbers
        tableView.reloadData()
    }
    
    func handleCFKeywords(cfKeywords: [CFKeyword]) {
        print("# MessageTVC.handleCFKeywords")
        keywords += cfKeywords
        tableView.reloadData()
    }
    
	func gotData(items:[JSON], type:String) {
//		if type == "leases" {
//			for item in items {
//				let num = CFNumber(withJSON: item)
//				print(num)
//			}
//		}
		/*
		for item in items as [JSON] {
			let contact = item["contact"]
			let homePhone = contact["homePhone"].stringValue
			let fromNumber = item["fromNumber"].stringValue
			print("\(homePhone) , \(fromNumber)")
		}
		*/
		
		tableView.reloadData()
	}

// MARK: - Table view data source
	
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if segmentedControl.selectedSegmentIndex == 0 {
			return actives.count + 1
		} else if segmentedControl.selectedSegmentIndex == 1 {
			return inactives.count + 1
		} else if segmentedControl.selectedSegmentIndex == 2 {
			return numbers.count + 1
		}
		return keywords.count + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier(segmentCellIdentifier, forIndexPath: indexPath) as UITableViewCell
		
		if indexPath.row == 0 {
			return cell
		}

		if segmentedControl.selectedSegmentIndex == 0 {
			(cell as! ActiveCell).active = actives[indexPath.row - 1]
		} else if segmentedControl.selectedSegmentIndex == 1 {
			(cell as! InactiveCell).inactive = inactives[indexPath.row - 1]
		} else if segmentedControl.selectedSegmentIndex == 2 {
			(cell as! NumbersCell).numbers = numbers[indexPath.row - 1]
		} else {
			(cell as! KeywordsCell).keywords = keywords[indexPath.row - 1]
		}
		return cell
    }

// MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
}

