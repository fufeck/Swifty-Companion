//
//  SkillViewController.swift
//  Swifty_companion
//
//  Created by Fabien TAFFOREAU on 10/19/16.
//  Copyright © 2016 Fabien TAFFOREAU. All rights reserved.
//


import UIKit

class SkillViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var skillSearchBar: UISearchBar! {
        didSet {
            skillSearchBar.delegate = self
        }
    }
    
    
    @IBOutlet weak var skillTableView: UITableView! {
        didSet {
            skillTableView.dataSource = self
            skillTableView.delegate = self
        }
    }
    
    var skills : NSMutableArray? = nil
    var searchskills : NSMutableArray = []
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchskills.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("skillCell", forIndexPath: indexPath) as! SkillTableCell
        cell.skill = self.searchskills[indexPath.row] as! NSDictionary
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.searchskills = self.skills!
        } else {
            let tmpSkills : NSMutableArray = []
            for skill in self.skills! {
                if let name : String = skill["name"]!! as? String {
                    if name.indexOf(searchText) != nil {
                        tmpSkills.addObject(skill)
                    }
                }
            }
            print(tmpSkills.count)
            self.searchskills = tmpSkills
        }
        self.skillTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.skills)
        self.searchskills = self.skills!
    }
}

class SkillTableCell : UITableViewCell {
    
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var skillBar: UIProgressView!
    
    
    var skill: NSDictionary! {
        didSet {
            if let level : Float = skill["level"] as? Float,
                let name : String = skill["name"] as? String {
                self.skillLabel.text = name + " : " + String(level)
                self.skillBar.progress = level / 20
            }
        }
    }
}

