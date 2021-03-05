//
//  ZoomedInImagePage.swift
//  School Binder
//
//  Created by Joshua Laurence on 10/08/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit

class ZoomedInImagePage: UIViewController, UIScrollViewDelegate {

    var zoomingImage = UIImage()
    @IBOutlet weak var ZoomedInImageImageView: UIImageView!
    @IBOutlet weak var ZoomedInImageScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ZoomedInImageScrollView.delegate = self
        ZoomedInImageScrollView.minimumZoomScale = 1.0
        ZoomedInImageScrollView.maximumZoomScale = 6.0
        ZoomedInImageScrollView.isUserInteractionEnabled = true
        ZoomedInImageScrollView.showsVerticalScrollIndicator = false
        ZoomedInImageScrollView.showsHorizontalScrollIndicator = false
        ZoomedInImageImageView.image = zoomingImage
        let swipedDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissing))
        swipedDown.direction = .down
        ZoomedInImageScrollView.addGestureRecognizer(swipedDown)
        // Do any additional setup after loading the view.
    }
    @objc func dismissing(_ swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case .down:
            if ZoomedInImageScrollView.zoomScale == 1.0 {
                self.dismiss(animated: false, completion: {
                    print("Dismissing")
                    zoomedImageDismissed = true
                })
            }
        default:
            print("Default Clause")
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.ZoomedInImageImageView
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
