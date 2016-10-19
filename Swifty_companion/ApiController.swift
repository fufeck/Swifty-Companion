//
//  ApiController.swift
//  Swifty_companion
//
//  Created by Fabien TAFFOREAU on 10/17/16.
//  Copyright © 2016 Fabien TAFFOREAU. All rights reserved.
//

import UIKit



class ApiController {
    static let api42 = ApiController()
    let client_id : String = "067f1e912068c107127c4a3b0ca8afec2559129fb9d365af21f4f87f8bb647e2"
    let client_secret : String = "a15e8d06ab10c54ad1c2ed6064a0fee75458e0d0c0c155f53faf759a1679e6e8"
    let endPoint : String = "https://api.intra.42.fr"
    var token: String?
    
    
    func getDic(data: NSData) -> NSDictionary? {
        do {
            if let dic : NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary {
                return dic
            }
        } catch (let err) {
            print("GET JSON ERROR :", err)
        }
        return nil
    }
    
    func getArray(data: NSData) -> NSMutableArray? {
        do {
            if let tab : NSMutableArray = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSMutableArray {
                return tab
            }
        } catch (let err) {
            print("GET JSON ERROR :", err)
        }
        return nil
    }
    
    
    func GetUser(login: String, responseHandler: (NSDictionary?) -> Void) {

        if self.token == nil {
            return responseHandler(nil)
        }
        let url = NSURL(string: self.endPoint + "/v2/users/" + login.lowercaseString)
        print("url : ", url)
        print("token : ", token)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("Bearer " + self.token!, forHTTPHeaderField: "Authorization")
        request.HTTPMethod = "GET"
        print("u")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            print("a")
            if error != nil {
                print("b")
                return responseHandler(nil)
            } else if data != nil {
                print("c")
                if let res = self.getDic(data!) {
                    print("d")

                    return responseHandler(res)
                } else {
                    print("e")

                    return responseHandler(nil)
                }
            }
            return responseHandler(nil)
        }
        task.resume()
    }
    
    /////////////////////////////////////
    /////////////AUTHENTIFICATE//////////
    /////////////////////////////////////
    
    func authentificate(completionHandler: (Bool) -> Void) {
        print("token : ", self.token)
        if self.token != nil {
            self.checkToken(completionHandler)
        } else {
            self.getToken(completionHandler)
        }
    }
    
    
    /////////////////////////////////////
    /////////////CHECK TOKEN/////////////
    /////////////////////////////////////
    
    func checkToken(completionHandler: (Bool) -> Void)  {
        
        print("check token")

        //CREATE URL
        let getEndpoint: String = self.endPoint + "/oauth/token/info"
        let url = NSURL(string: getEndpoint)
        
        //CREATE REQUEST
        let request = NSMutableURLRequest(URL: url!)
        request.setValue("Bearer " + self.token!, forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        //SEND REQUEST
        let task  = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error != nil {
                return self.getToken(completionHandler)
            }
            return completionHandler(true)
        }
        task.resume()
    }
    
    /////////////////////////////////////
    /////////////GET TOKEN///////////////
    /////////////////////////////////////
    
    
    func getToken(completionHandler: (Bool) -> Void) {

        print("get token")
        //CREATE URL
        let postEndpoint: String =  self.endPoint + "/oauth/token"
        let url = NSURL(string: postEndpoint)!
        
        
        //CREATE REQUEST
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let postParams : [String: AnyObject] = [
            "grant_type": "client_credentials",
            "client_id": self.client_id,
            "client_secret": self.client_secret
        ]
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
        } catch {
            return completionHandler(false)
            
        }
        print("u")
        //SEND REQUEST
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            print("a")
            if error != nil {
                print("b")
                return completionHandler(false)
            } else if let d = data {
                print("c")
                if let json = self.getDic(d) {
                    print("d")
                    if let access_token = json["access_token"] as? String {
                        print("e")
                        self.token = access_token
                        return completionHandler(true)
                    }
                }
                return completionHandler(false)
            }
        }
        print("x")
        task.resume()
    }
    

    
    
}