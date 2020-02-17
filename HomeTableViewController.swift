//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Briana Williams on 2/16/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    
    
    var tweetArray = [NSDictionary]()
    var numberOfTweet : Int!
    
    let myRefreshControl = UIRefreshControl()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        //refreshes the page
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        self.tableView.refreshControl = myRefreshControl

    }
    
    
    //pull the tweets from twitter
    @objc func loadTweets(){
        
        numberOfTweet = 20
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams as [String : Any], success: {(tweets:[NSDictionary]) in
            //removes old tweets in the array
            self.tweetArray.removeAll()
            //loads new tweets and add them to the array
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            //reload the data
            self.tableView.reloadData()
            
            //end refreshing
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Couldn't retrieve any tweets")
        })
        
        
        
    }
    
    //infinite scrolling
    func loadMoreTweets(){
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        numberOfTweet = numberOfTweet + 20
        
        let myParams = ["count": numberOfTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams as [String : Any], success: {(tweets:[NSDictionary]) in
                //removes old tweets in the array
                self.tweetArray.removeAll()
                //loads new tweets and add them to the array
                for tweet in tweets{
                    self.tweetArray.append(tweet)
                }
                //reload the data
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
                
              
                
            }, failure: { (Error) in
                print("Couldn't retrieve any tweets")
            })
        
    }
    
    
    //run the function loadMoreTweets
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count{
            loadMoreTweets()
        }
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        
        //to logout of twitter
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        
        
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        
        let imageUrl = URL(string:(user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data{
            cell.profileImageView.image = UIImage(data:imageData )
        }
        
        return cell
    }
    // MARK: - Table view data source
//how many sections do you want
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
//how many rows per section do you want
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

}
