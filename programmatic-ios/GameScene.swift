//
//  GameScene.swift
//  spritekit-game-ios
//
//  Created by James on 5/15/20.
//  Copyright © 2020 jjlljj. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    let player = SKSpriteNode(color: UIColor.blue, size: CGSize(width:20, height:40))

    override func didMove(to view: SKView) {
      super.didMove(to:view)
      backgroundColor = SKColor.white

     
      player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
      addChild(player)
      print("SCENE DID MOVE")
      print(size)
    }
    
    override func sceneDidLoad() {
      super.sceneDidLoad()
      print("SCENE DID LOAD")
    }
}
