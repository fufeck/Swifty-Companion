//
//  UserViewController.swift
//  Swifty_companion
//
//  Created by Fabien TAFFOREAU on 10/17/16.
//  Copyright © 2016 Fabien TAFFOREAU. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    let queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    
    var user : NSDictionary?

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var correctionLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var lvlView: UIView!
    @IBOutlet weak var lvlLabel: UILabel!
    @IBOutlet weak var lvlBar: UIProgressView!

    @IBOutlet weak var buttonView: UIView!
    
    func createImage(login : String) {
        dispatch_async(self.queue) {
            if let url = NSURL(string: "https://cdn.intra.42.fr/users/medium_" + login + ".jpg") {
                if let data = NSData(contentsOfURL: url) {
                    dispatch_async(dispatch_get_main_queue()) {
                        let image : UIImage = UIImage(data: data)!
                        self.userImage.image = image
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ProjectSegue" {
            if let vc = segue.destinationViewController as? ProjectViewController {
                vc.projects = user?["projects_users"] as? NSMutableArray
            }
        } else if segue.identifier == "SkillSegue" {
            if let vc = segue.destinationViewController as? SkillViewController {
                vc.skills = user?["cursus_users"]?[0]?["skills"] as? NSMutableArray
            }
        } else if segue.identifier == "AchivementSegue" {
            if let vc = segue.destinationViewController as? AchivementViewController {
                vc.achivements = user?["achievements"] as? NSMutableArray
            }
        }

    }
    
    func createViewUser() {
        print(user)
        self.buttonView.layer.cornerRadius = 4
        self.buttonView.layer.borderWidth = 1
        self.buttonView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.barView.layer.cornerRadius = 4
        self.barView.layer.borderWidth = 1
        self.barView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.lvlView.layer.cornerRadius = 4
        self.lvlView.layer.borderWidth = 1
        self.lvlView.layer.borderColor = UIColor.lightGrayColor().CGColor
        if let login : String = user?["login"] as? String {
            createImage(login)
            self.loginLabel?.text = login
        }
        if let name : String = user?["displayname"] as? String {
            self.nameLabel?.text = name
        }
        if let email : String = user?["email"] as? String {
            self.emailLabel?.text = email
        }
        if let phone : String = user?["phone"] as? String {
            self.phoneLabel?.text = phone
        }
        if let location : String = user?["location"] as? String {
            self.locationLabel?.text = location
        }
        if let wallet : Int = user?["wallet"] as? Int {
            self.walletLabel?.text = "Wallet : " + String(wallet)
        }
        if let correction : Int = user?["correction_point"] as? Int {
            self.correctionLabel?.text = "Correction points : " + String(correction)
        }
        if let grade : String = user?["cursus_users"]?[0]?["grade"] as? String {
            self.gradeLabel?.text = "Grade : " + grade
        }
        if let lvl : Float = user?["cursus_users"]?[0]?["level"] as? Float {
            print("lvl :", String(lvl))
            let level : [String] = String(lvl).componentsSeparatedByString(".")
            self.lvlLabel?.text = "Level : " + level[0] + " - " + level[1] + "%"
            self.lvlBar.progress = Float(level[1])! / 100
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createViewUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension String {
    func indexOf(string: String) -> String.Index? {
        return lowercaseString.rangeOfString(string.lowercaseString , options: .LiteralSearch, range: nil, locale: nil)?.startIndex
    }
}