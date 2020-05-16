//
//  GameScene.swift
//  spritekit-game-ios
//
//  Created by James on 5/15/20.
//  Copyright © 2020 jjlljj. All rights reserved.
//

import SpriteKit

func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
  return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}

class GameScene: SKScene {
  
  let player = SKSpriteNode(color: UIColor.blue, size: CGSize(width:20, height:40))
  
  override func didMove(to view: SKView) {
    super.didMove(to:view)
    backgroundColor = SKColor.white
    
    
    player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
    addChild(player)
    
    run(SKAction.repeatForever(
      SKAction.sequence([
        SKAction.run(addMonster),
        SKAction.wait(forDuration: 1.5)
      ])
    ))
  }
  
  override func sceneDidLoad() {
    super.sceneDidLoad()
    print("SCENE DID LOAD")
  }
  
  func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 4294967296)
  }
  
  func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
  }
  
  func addMonster() {
    let monster = SKSpriteNode(color: UIColor.red, size: CGSize(width:30, height:30))
    
    //let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
    let actualX = random(min: monster.size.width/2, max: size.width - monster.size.width/2)
    
    //monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
    monster.position = CGPoint(x: actualX, y: size.height + monster.size.height/2)
    
    addChild(monster)
    
    let actualDuration = random(min: CGFloat(5.0), max: CGFloat(8.0))
    
    //let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
    let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -monster.size.height/2), duration: TimeInterval(actualDuration))
    let actionMoveDone = SKAction.removeFromParent()
    monster.run(SKAction.sequence([actionMove, actionMoveDone]))
  }
  
//   func addMonster() {
//      let monster = SKSpriteNode(color: UIColor.red, size: CGSize(width:30, height:30))
//      
//      let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
//      //let actualX = random(min: monster.size.width/2, max: size.width - monster.size.width/2)
//
//      
//      monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
//      
//      addChild(monster)
//      
//      let actualDuration = random(min: CGFloat(4.0), max: CGFloat(6.0))
//      
//      let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
//      
//  //    let actualX = random(min: monster.size.width/2, max: size.width - monster.size.width/2)
//  //
//  //    //monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
//  //    monster.position = CGPoint(x: actualX, y: size.height + monster.size.height/2)
//  //
//  //    addChild(monster)
//  //
//  //    let actualDuration = random(min: CGFloat(4.0), max: CGFloat(6.0))
//  //
//  //    let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -monster.size.height/2), duration: TimeInterval(actualDuration))
//      
//      
//      let actionMoveDone = SKAction.removeFromParent()
//      monster.run(SKAction.sequence([actionMove, actionMoveDone]))
//    }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    
    let touchLocation = touch.location(in: self)
    
    let projectile = SKSpriteNode(color: UIColor.purple, size: CGSize(width:2, height:6))
    projectile.position = player.position
    
    
    let offset = touchLocation - projectile.position
    
    if offset.y < 0 { return }
    
    addChild(projectile)
    
    let direction = offset.normalized()
    
    let shootAmount = direction * 1000
    
    let realDestination = shootAmount + projectile.position
    let actionMove = SKAction.move(to: realDestination, duration: 2.5)
    let actionMoveDone = SKAction.removeFromParent()
    projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
  }
}
