//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Gabriel Rivera on 2/12/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    //array that stores tweets in a dictionary
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //call this method to load tweets
        
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.loadTweets()
        
        
        
    }
    
    
    //calls API for Twitter
    
    @objc  func  loadTweets(){
        
        numberOfTweet = 20
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
       
        //this gives count of records; see Twitter API documentation on Getting Tweet Timelines
        let myParams = ["count": numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            //removes tweets in array
            self.tweetArray.removeAll()
            
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            
            self.myRefreshControl.endRefreshing()
            
            
        }, failure: { (Error) in
            print("Could not load Tweets!")
        })
        
    }
 
    
    func loadMoreTweets(){
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        numberOfTweet = numberOfTweet + 20
        
        let myParams = ["count": numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            //removes tweets in array
            self.tweetArray.removeAll()
            
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            
           self.myRefreshControl.endRefreshing()
            
            
        }, failure: { (Error) in
            print("Could not load Tweets!")
        })

        
        
    }
 
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == tweetArray.count{
            
            loadMoreTweets()
            
        }
        
    }
 

    
    

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        
        //screen dismisses itself
        self.dismiss(animated: true, completion: nil)
        
        //When user taps Logout button, this line of code requires user to Login again
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //this variable allows to get outlets or properties in TweetCell.swift
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        
        //changes default text
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        //cell grabs variables in Tweet Cell swift file
        //checks attribute "favorited" as a boolean
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        
        //checks attribute "id" as a Integer
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        
        //checks attribute "retweeted" as a boolean
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //returns how many tweets were recieved
        return tweetArray.count
    }

   
}
