//
//  LoginViewController.swift
//  Twitter
//
//  Created by Briana Williams on 2/16/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //check to see if the user is logged in
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true{
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }

    @IBAction func onLoginButton(_ sender: Any) {
        
        
    //twitter API call
        let URL = "https://api.twitter.com/oauth/request_token"
        //which URL do you want to call, when called what do you want to do when it workd and when it doesn't
        TwitterAPICaller.client?.login(url: URL, success: {
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            self.performSegue(withIdentifier: "loginToHome", sender: self)}, failure: { (Error) in
            print("Could not login!")
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
