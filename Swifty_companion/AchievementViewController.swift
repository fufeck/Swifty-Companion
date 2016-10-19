//
//  AchievementViewController.swift
//  Swifty_companion
//
//  Created by Fabien TAFFOREAU on 10/19/16.
//  Copyright © 2016 Fabien TAFFOREAU. All rights reserved.
//

import UIKit

class AchivementViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var achivementSearchBar: UISearchBar! {
        didSet {
            achivementSearchBar.delegate = self
        }
    }
    
    @IBOutlet weak var achivementTableView: UITableView! {
        didSet {
            achivementTableView.dataSource = self
            achivementTableView.delegate = self
        }
    }
    
    var achivements : NSMutableArray? = nil
    var searchAchivements : NSMutableArray = []
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchAchivements.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("achivementCell", forIndexPath: indexPath) as! AchivementTableCell
        cell.achivement = self.searchAchivements[indexPath.row] as! NSDictionary
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.searchAchivements = self.achivements!
        } else {
            let tmpSkills : NSMutableArray = []
            for skill in self.achivements! {
                if let name : String = skill["name"]!! as? String {
                    if name.indexOf(searchText) != nil {
                        tmpSkills.addObject(skill)
                    }
                }
            }
            print(tmpSkills.count)
            self.searchAchivements = tmpSkills
        }
        self.achivementTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.achivements)
        self.searchAchivements = self.achivements!
    }
}

class AchivementTableCell : UITableViewCell {
    let queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    
    @IBOutlet weak var achivementImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var achivement: NSDictionary! {
        didSet {
            print(achivement)
            if let name : String = achivement["name"] as? String {
                self.nameLabel?.text = name
            }
            if let description : String = achivement["description"] as? String {
                self.descLabel?.text = description
            }
            
            if let img : String = achivement["image"] as? String {
                dispatch_async(self.queue) {
                    if let url = NSURL(string: "https://api.intra.42.fr" + img) {
                        if let data = NSData(contentsOfURL: url) {
                            dispatch_async(dispatch_get_main_queue()) {
                                let image : UIImage = UIImage(data: data)!
                                self.achivementImage.image = image
                            }
                        }
                    }
                }
            }

        }
    }
}


