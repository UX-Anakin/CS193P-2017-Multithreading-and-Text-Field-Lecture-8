//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Michel Deiman on 13/03/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {

    // Set CassiniViewController as the UISplitViewControllerDelegate
    // Do it early when it directly out of the storyboard.
    // could be done in ViewDidLoad (== later)
    override func awakeFromNib() {
        self.splitViewController?.delegate = self
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let url = DemoURL.NASA[segue.identifier ?? ""],
            let imageVC = segue.destination.contents as? ImageViewController
        {
            imageVC.imageURL = url
            imageVC.title = (sender as? UIButton)?.currentTitle
        }
    }
    
    
    // MARK: - UISplitViewControllerDelegate method
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool
    {
        if primaryViewController.contents == self,
            let ivc = secondaryViewController.contents as? ImageViewController
        {
            return ivc.imageURL == nil
        }
        return false
    }
}

// MARK: - Extension to UIViewController, in case it is in a NavigationController
extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
