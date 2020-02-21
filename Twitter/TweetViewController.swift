//
//  TweetViewController.swift
//  Twitter
//
//  Created by Gabriel Rivera on 2/19/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit
//import RSKPlaceholderTextView

class TweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBOutlet weak var characterLimit: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder()

        // Do any additional setup after loading the view.
        //most of the time, put delagates in viewDidLoad()
        self.tweetTextView.delegate = self
        
         
    }
    

    @IBAction func cancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       // Set the max character limit
       let tweetLimit = 140

       // Construct what the new text would be if we allowed the user's latest edit
       let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)

       // TODO: Update Character Count Label
        let numberOfCharacters = tweetLimit - newText.count
        characterLimit.text = String("\(numberOfCharacters) / \(tweetLimit)")

       // The new text should be allowed? True/False
        return newText.count < tweetLimit
    }
 
    
    @IBAction func tweet(_ sender: Any) {
        if(!tweetTextView.text.isEmpty){
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (Error) in
                print("Error posting tweet: \(Error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
            
        }
        
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
