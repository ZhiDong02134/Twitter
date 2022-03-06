    //
    //  HomeTableViewController.swift
    //  Twitter
    //
    //  Created by Danny Dong on 3/1/22.
    //  Copyright © 2022 Dan. All rights reserved.
    //

import UIKit

class HomeTableViewController: UITableViewController {
    
    
    var tweets = [NSDictionary]()
    var tweetCount: Int!
    let myRefreshControl = UIRefreshControl()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweets()
    }


 
    @IBAction func onLogOutClick(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
        // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
        return tweets.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweets[indexPath.row]["user"] as! NSDictionary
                cell.usernameLabel.text = user["name"] as? String
                cell.tweetContent.text = tweets[indexPath.row]["text"] as? String
                
                let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
                let data = try? Data(contentsOf: imageUrl!)
                
                if let imageData = data {
                    cell.profileImage.image = UIImage(data: imageData)
                }
       
        cell.setFavorite(tweets[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweets[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweets[indexPath.row]["retweeted"] as! Bool)
        return cell
    }
    
    @objc func loadTweets() {
        tweetCount = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": tweetCount]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any], success: { (tweetList: [NSDictionary]) in
            self.tweets.removeAll()
            for tweet in tweetList {
                self.tweets.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
    }
    
    func loadMoreTweets(){
            let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
            tweetCount += 20
        print(tweetCount!)
            let myParams = ["count": tweetCount]
            
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any], success: { (tweetList: [NSDictionary]) in
            self.tweets.removeAll()
            for tweet in tweetList {
                self.tweets.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweets.count {
            loadTweets()
        }
    }
}
