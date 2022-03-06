//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Danny Dong on 3/1/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    var favorited: Bool = false
    var tweetId: Int = -1
    var retweeted: Bool = false
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onFavoritePress(_ sender: Any) {
        if (!favorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { Error in
                print("unable to favorite tweet")
            })
            return
        }
        TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
            self.setFavorite(false)
        }, failure: { Error in
            print("unable to unfavorite tweet")
        })

    }
    
    @IBAction func onRetweetPress(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                }, failure: { (error) in
                    print("Error in retweeting: \(error)")
                })
        retweeted = !retweeted
        setRetweeted(retweeted)
        
    }
    
    func setFavorite(_ isFavorited: Bool) {
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
            return
        }
        
        favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
    }
    
    func setRetweeted(_ isRetweeted: Bool) {
            if (isRetweeted) {
                retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
                retweetButton.isEnabled = false
            } else {
                retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
                retweetButton.isEnabled = true
            }
        }
}
