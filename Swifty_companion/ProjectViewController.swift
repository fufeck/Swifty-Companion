//
//  ProjectViewController.swift
//  Swifty_companion
//
//  Created by Fabien TAFFOREAU on 10/19/16.
//  Copyright © 2016 Fabien TAFFOREAU. All rights reserved.
//


import UIKit

class ProjectViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var projectSearchBar: UISearchBar! {
        didSet {
            projectSearchBar.delegate = self
        }
    }
    
    
    @IBOutlet weak var projectTableView: UITableView! {
        didSet {
            projectTableView.dataSource = self
            projectTableView.delegate = self
        }
    }
    
    var projects : NSMutableArray? = nil
    var searchProjects : NSMutableArray = []


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchProjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("projectCell", forIndexPath: indexPath) as! ProjectTableCell
        cell.project = self.searchProjects[indexPath.row] as! NSDictionary
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.searchProjects = self.projects!
        } else {
            let tmpProjects : NSMutableArray = []
            for project in self.projects! {
                if let name : String = project["project"]!!["name"] as? String {
                    if name.indexOf(searchText) != nil {
                        tmpProjects.addObject(project)
                    }
                }
            }
            print(tmpProjects.count)
            self.searchProjects = tmpProjects
        }
        self.projectTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchProjects = self.projects!
    }
}

class ProjectTableCell : UITableViewCell {
    
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    var project: NSDictionary! {
        didSet {
            if let name : String = project["project"]!["name"] as? String {
                self.projectLabel?.text = name
            }
            if let status : String = project["status"]! as? String {
                var rate : String = ""
                if status == "finished",
                let validated : Int = project["validated?"]! as? Int,
                let final_mark : Int = project["final_mark"]! as? Int {
                    
                    if validated == 1 {
                        rate += "Succeeded "
                        self.rateLabel.textColor = UIColor.greenColor()
                        self.projectLabel.textColor = UIColor.greenColor()
                    } else {
                        rate += "Failed "
                        self.rateLabel.textColor = UIColor.redColor()
                        self.projectLabel.textColor = UIColor.redColor()
                    }
                    rate += "with " + String(final_mark) + " %"
                    
                } else if status == "in_progress" {
                    rate += "In progress"
                    self.rateLabel.textColor = UIColor.yellowColor()
                    self.projectLabel.textColor = UIColor.yellowColor()
                } else if status == "waiting_for_correction" {
                    rate += "Waiting for correction"
                    self.rateLabel.textColor = UIColor.yellowColor()
                    self.projectLabel.textColor = UIColor.yellowColor()
                }
                self.rateLabel?.text = rate
            }
        }
    }
    

    
}