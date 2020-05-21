//
//  File.swift
//  spritekit-game-ios
//
//  Created by James on 5/20/20.
//  Copyright © 2020 jjlljj. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
  init(size: CGSize, won:Bool) {
    super.init(size: size)
    
    let message = won ? "You Won!" : "You Lose :("
    
    let label = SKLabelNode(fontNamed: "Chalkduster")
    label.text = message
    label.fontSize = 40
    label.fontColor = SKColor.white
    label.position = CGPoint(x: size.width/2, y: size.height/2)
    addChild(label)

    run(SKAction.sequence([
      SKAction.wait(forDuration: 5.0),
      SKAction.run() { [weak self] in
        // 5
        guard let `self` = self else { return }
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let scene = GameScene(size: size)
        self.view?.presentScene(scene, transition:reveal)
      }
      ]))
   }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
