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

	var active : Active? {
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
	
	var inactive : Inactive? {
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
	
	var numbers : Numbers? {
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
	
	var keywords : Keywords? {
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
	
	var active = [Active]()
	var inactive = [Inactive]()
	var numbers = [Numbers]()
	var keywords = [Keywords]()
	
	var segmentCellIdentifier = "ActiveCell"
	
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
		
		// STUB DATA
		let activeJSON = JSON(["name":"Active Broadcast","calls":"42","progress":"24%"])
		let activeData = Active(withJSON: activeJSON)
		active.append(activeData)
		
		let inactiveJSON = JSON(["name":"Inactive Broadcast","calls":"108","progress":"100%"])
		let inactiveData = Inactive(withJSON: inactiveJSON)
		inactive.append(inactiveData)
		
		let numbersJSON = JSON(["name":"(310) 555-1234","calls":"100","transfers":"60","missed":"40","texts":"50"])
		let numbersData = Numbers(withJSON: numbersJSON)
		numbers.append(numbersData)
		
		let keywordsJSON = JSON(["name":"TEST","texts":"20"])
		let keywordsData = Keywords(withJSON: keywordsJSON)
		keywords.append(keywordsData)
		
		
		let manager = APIManager()
		manager.getData("/numbers/leases", handler: {items in
			self.gotData(items,type:"leases")
		})

		tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	func gotData(items:[JSON], type:String) {
		if type == "leases" {
			for item in items {
				let num = Numbers(withJSON: item)
				print(num)
			}
		}
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
			return active.count + 1
		} else if segmentedControl.selectedSegmentIndex == 1 {
			return inactive.count + 1
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
			(cell as! ActiveCell).active = active[indexPath.row - 1]
		} else if segmentedControl.selectedSegmentIndex == 1 {
			(cell as! InactiveCell).inactive = inactive[indexPath.row - 1]
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

