//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse
//lets import the FBSDK
import FBSDKCoreKit

class ViewController: UIViewController {

    //we want a button for users to login with facebook
    //now we want the user to only login when they use the button, not everytime the app starts like if we inserted this into viewDidLoad
    @IBAction func btnSignIn(sender: AnyObject) {
        //lets create a variable called permissions, that is an array that details what we want to get from the user's fb acccount. there are many options for data that you can get, such as friends list, etc. we also need to get the users email addkres
        let permissions = ["public_profile", "email"]
        
        //we don't want publish permissions like writing on peoples walls. we want users account info
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            
            //at this point facebook is opening safari, and seeing if a facebook user is loggedin, if the user is logged in, facebook will return the user or an error. typically the user has logged in at least once and is notified in safari. once authorized, facebook returns the user or an error
            
            //the variables we are expecting are user, so let's get that user and populate in parse. and it is optional because we don't know if it will work. we are not returning anythings, so we use void
            (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                print(error)
            } else {
                if let user = user {
                    
                    //print(user)
                    //lets check to see that we are getting the information back about the user that tells us they actually signed up. that is, they have interestedInWomen boolean yes or no
                    if let interestedInWomen = user["interestedInWomen"] {
                        //if we know they are signed up already we can get send them to the view controller that enables them to start swiping left and right.
                        //print("the user is \(user) and we know that they are interested in women")
                        self.performSegueWithIdentifier("logUserIn", sender: self)
                        
                    } else {
                        
                        //if the user has not yet checked if they are interested in women or no (that is interestedInWomen exists, we want to perform the segue showSignInScreen. the identifier is the segue name.
                        self.performSegueWithIdentifier("showSignInScreen", sender: self)
                    }
                

    
                }
            }
            
        } )
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

  /*

        //now what if we wanted to send a push notification?
        //lets use Parse Channels to send out our notifications.
        // When users indicate they are Giants fans, we subscribe them to that channel.
        // Send a notification to all devices subscribed to the "Giants" channel.
        // note, this is actually sending messages from the the device
        let push = PFPush()
        push.setChannel("Giants")
        push.setMessage("The Giants just scored!")
        push.sendPushInBackground()
            //a channel is a way to send a push notification from one device to another. and we can assign particular devices particular channels. so you could send a notification to a certain set of channels. just set the channel, set the message, and send the push in the background.

  */
        

        
    }
    
    
    //remember segues have to be managed in the viewDidAppear method. below we are looking to see if the current PFUser username matches from facebook,
    
    override func viewDidAppear(animated: Bool) {
        //for testing lets have some code to log the user out
        //PFUser.logOut()
        
    
        //we want to initiate the segue if hte user is logged in.
        if let username = PFUser.currentUser()?.username {
            //if the username from facebook exists we want to perform the segue. the identifier is the segue name.
            
            //For right now lets not perform the segue
            //performSegueWithIdentifier("showSignInScreen", sender: self)
            
            //lets check to see that the current user actually signed up. that is, they have interestedInWomen boolean yes or no
            if let interestedInWomen = PFUser.currentUser()?["interestedInWomen"] {
                //if we know they are signed up already we can get send them to the view controller that enables them to start swiping left and right.
                self.performSegueWithIdentifier("logUserIn", sender: self)
                
            } else {
                
                //if the username from facebook exists we want to perform the segue. the identifier is the segue name.
                self.performSegueWithIdentifier("showSignInScreen", sender: self)
            }

            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

