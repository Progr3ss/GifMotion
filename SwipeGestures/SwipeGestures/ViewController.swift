//
//  ViewController.swift
//  SwipeGestures
//
//  Created by Martin Chibwe on 10/27/17.
//  Copyright © 2017 Martin Chibwe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var viewTap: UIView!
   

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func swipeDirections()  {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(sender:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.viewTap.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(sender:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.viewTap.addGestureRecognizer(swipeRight)
    }
    
    func swipeAction(sender:UISwipeGestureRecognizer)  {
        switch sender.direction.rawValue {
        case 1:
            print("case 1 \(sender.direction.rawValue)")
        case 2:
            print("case 2 \(sender.direction.rawValue)")
        default:
            break
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

