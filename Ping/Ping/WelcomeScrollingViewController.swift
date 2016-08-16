//
//  WelcomeScrollingViewController.swift
//  Ping
//
//  Created by Martin Zhang on 2016-08-14.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

import UIKit

class WelcomeScrollingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let scrollViewWidth: CGFloat = self.scrollView.frame.width
        let scrollViewHeight: CGFloat = self.scrollView.frame.height
        
        self.startButton.layer.cornerRadius = 4.0
        
        let imgOne = UIImageView(frame: CGRectMake(0, 0,scrollViewWidth, scrollViewHeight))
        imgOne.image = UIImage(named: "vancouver")
        let imgTwo = UIImageView(frame: CGRectMake(scrollViewWidth, 0,scrollViewWidth, scrollViewHeight))
        imgTwo.image = UIImage(named: "iphone")
        let imgThree = UIImageView(frame: CGRectMake(scrollViewWidth*2, 0,scrollViewWidth, scrollViewHeight))
        imgThree.image = UIImage(named: "cheers")
        let imgFour = UIImageView(frame: CGRectMake(scrollViewWidth*3, 0,scrollViewWidth, scrollViewHeight))
        imgFour.image = UIImage(named: "concert")
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 4, self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        // Change the text accordingly
        if Int(currentPage) == 3 {
            
            // Show the "Let's Start" button in the last slide (with a fade in animation)
            UIView.animateWithDuration(1.0) {
                self.startButton.alpha = 1.0
            }
        }
    }

    @IBAction func startButtonPressed(sender: AnyObject) {
//        performSegueWithIdentifier("showLoginViewController", sender: self)
        [self.dismissViewControllerAnimated(true, completion: nil)]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
