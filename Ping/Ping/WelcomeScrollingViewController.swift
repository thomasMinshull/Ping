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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.scrollView.contentInset = UIEdgeInsetsZero
        let scrollViewWidth: CGFloat = self.scrollView.frame.width
        let scrollViewHeight: CGFloat = self.scrollView.frame.height
        
        self.startButton.layer.cornerRadius = 4.0
        
        let imageOneLocationX: CGFloat = 0
        let imageTwoLocationX: CGFloat = scrollViewWidth
        let imageThreeLocationX: CGFloat = scrollViewWidth * 2
        let imageFourLocationX: CGFloat = scrollViewWidth * 3
        
        let imgOne = UIImageView(frame: CGRectMake(imageOneLocationX, -20,scrollViewWidth+20, scrollViewHeight+40))
        imgOne.image = UIImage(named: "vancouver")
        let imgTwo = UIImageView(frame: CGRectMake(imageTwoLocationX, -20,scrollViewWidth+20, scrollViewHeight+40))
        imgTwo.image = UIImage(named: "iphone")
        let imgThree = UIImageView(frame: CGRectMake(imageThreeLocationX, -20,scrollViewWidth+20, scrollViewHeight+40))
        imgThree.image = UIImage(named: "cheers")
        let imgFour = UIImageView(frame: CGRectMake(imageFourLocationX, -20,scrollViewWidth+20, scrollViewHeight+40))
        imgFour.image = UIImage(named: "concert")
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 4, 0)
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
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
}
