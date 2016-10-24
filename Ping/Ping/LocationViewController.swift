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
    func sendData(_ text:String)
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
        
        resultsViewController?.tableCellBackgroundColor = UIColor.clear
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        completionButton.isHidden = true
        
        let subView = UIView(frame: CGRect(x: 0.0, y: 66.0, width: self.view.frame.width, height: 66.0))
        
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
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "NewLocationVCToNewEventVC", sender: self)
    }
    
    @IBAction func completeButtonPressed(_ sender: AnyObject) {
        self.delegate?.sendData(resultTextView.text)
        performSegue(withIdentifier: "NewLocationVCToNewEventVC", sender: self)
    }
    
}

// Handle the user's selection.
extension LocationViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        resultTextView?.text = place.name
        
        completionButton.isHidden = false
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
