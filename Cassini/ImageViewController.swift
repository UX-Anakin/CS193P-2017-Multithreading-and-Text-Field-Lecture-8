//
//  ImageViewController.swift
//  Cassini
//
//  Created by Stanford's Instructor on 08/03/2017.
//  Copyright © 2017 Stanford. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController
{
    // MARK: - Model
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {     // on screen?
                fetchImage()
            }
        }
    }
    
    fileprivate var imageView = UIImageView()
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    /** Fetch the data asynchronously on a different thread..
     */
    private func fetchImage() {
        if  let url = imageURL {
            spinner.startAnimating()
            // maintain responsiveness of your UI by using a different thread...
            // But user might be waiting, so QoS = .userInitiated, which is high
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.imageURL {
                    // UI stuff is done on the Main Queue...
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 3.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
 
//  other labels that could be used...
//    MARK: Need to work on this one
//    FIXME: Need to implement ...
//    TODO: - Needs to do :

    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            spinner?.stopAnimating()
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
}

//    MARK: In an extension, the ImageViewController is conforming to the delegate
//          for UIScrollView.
extension ImageViewController:  UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
