//
//  DetailViewController.swift
//  rotten
//
//  Created by Ziyang Tan on 9/22/14.
//  Copyright (c) 2014 ziyang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var detailPosterView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var synopsisLabel: UILabel!


    @IBOutlet weak var networkErrorView: UIView!
    
    var movieId: String = ""

    var movie: NSDictionary = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.networkErrorView.alpha = 0;
        self.networkErrorView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)

        var detailURL = "http://api.rottentomatoes.com/api/public/v1.0/movies/" + movieId + ".json?apikey=dagqdghwaq3e3mxyrp7kmmj5"

        var request = NSURLRequest(URL:NSURL(string: detailURL))

        var session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request,
            completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) in

                if error == nil {

                    dispatch_async(dispatch_get_main_queue()) {
                        var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                        self.movie = object as NSDictionary
                        var posters = self.movie["posters"] as NSDictionary
                        var posterURL = posters["original"] as String

                        self.navigationItem.title = self.movie["title"] as? String
                        self.titleLabel.text = self.movie["title"] as? String
                        self.synopsisLabel.text = self.movie["synopsis"] as? String
                        self.detailPosterView.setImageWithURL(NSURL(string: posterURL))
                    }
                }
                else {
                    self.showNetworkError()
                }

        }).resume()

        contentView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)

        titleLabel.textColor = UIColor.whiteColor()
        synopsisLabel.textColor = UIColor.whiteColor()

    }

    func showNetworkError() {
        dispatch_async(dispatch_get_main_queue()) {
            self.networkErrorView.alpha = 1
            let offset = 3.0
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(offset * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.networkErrorView.alpha = 0
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}