//
//  MainViewController.swift
//  programmatic-ios
//
//  Created by James on 4/30/20.
//  Copyright © 2020 jjlljj. All rights reserved.
//

import UIKit
import SpriteKit

class MainViewController: UIViewController {
  
  override func loadView() {
    self.view = SKView(frame:CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    
//    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//    backgroundImage.image = UIImage(named: "bg.png")
//    backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
//    view.insertSubview(backgroundImage, at: 0)

    let scene = GameScene(size: UIScreen.main.bounds.size)
    NSLog("scene size = \(UIScreen.main.bounds.size)")
    
    let skView = view as! SKView
    skView.showsFPS = true
    skView.showsNodeCount = true
    //skView.ignoresSiblingOrder = true
    scene.scaleMode = .resizeFill
    skView.presentScene(scene)
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
  }
  
}
