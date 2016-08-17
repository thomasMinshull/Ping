//
//  LocationViewController.swift
//  Ping
//
//  Created by Jeff Eom on 2016-08-16.
//  Copyright © 2016 thomas minshull. All rights reserved.
//
import UIKit
import GooglePlaces

@objc protocol SendDataDelegate {
    func sendData(text:String)
}

class LocationViewController: UIViewController{
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var completionButton: UIButton!
    
    var delegate: SendDataDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        resultsViewController?.tableCellBackgroundColor = UIColor.clearColor()
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        completionButton.hidden = true
        
        let subView = UIView(frame: CGRectMake(0.0, 66.0, self.view.frame.width, 66.0))
        
        subView.addSubview((searchController?.searchBar)!)
        self.view.addSubview(subView)
        self.view.addSubview(resultTextView)
        
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.backgroundImage = UIImage.init(named: "Rectangle 2")
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        self.definesPresentationContext = true
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("NewLocationVCToNewEventVC", sender: self)
    }
    
    @IBAction func completeButtonPressed(sender: AnyObject) {
        self.delegate?.sendData(resultTextView.text)
        performSegueWithIdentifier("NewLocationVCToNewEventVC", sender: self)
    }
    
}

// Handle the user's selection.
extension LocationViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWithPlace place: GMSPlace) {
        searchController?.active = false
        // Do something with the selected place.
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        resultTextView?.text = place.name
        
        completionButton.hidden = false
    }
    
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: NSError){
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}
