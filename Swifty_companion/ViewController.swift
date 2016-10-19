//
//  ViewController.swift
//  Swifty_companion
//
//  Created by Fabien TAFFOREAU on 10/17/16.
//  Copyright © 2016 Fabien TAFFOREAU. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    var user : NSDictionary?
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UserSegue" {
            if let vc = segue.destinationViewController as? UserViewController {
                vc.user = self.user
                vc.title = self.user!["login"] as! String
            }
        }
    }
    
    func showAlert(title : String, message : String) {
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
            self.showAlert("tata", message: "Please Enter Text In The Box")
        } else {
            ApiController.api42.GetUser(searchBar.text!, responseHandler: {
                (response : NSDictionary?) in
                dispatch_async(dispatch_get_main_queue()) {
                    print(response)
                    if let _ : String = response?["displayname"] as? String {
                        self.user = response
                        self.performSegueWithIdentifier("UserSegue", sender: "Foo")
                        return
                    } else {
                        self.showAlert("tata", message: "Please Enter Text In The Box")
                        return
                    }
                    return
                }
            })
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        ApiController.api42.authentificate {
            (success: Bool) in
            if success {
                print("authentification success")
            } else {
                 self.showAlert("Authentification fail", message: "Swifty companion can't connect to api42")
                print("authentification fail")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

