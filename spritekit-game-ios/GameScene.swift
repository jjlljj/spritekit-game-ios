//
//  GameScene.swift
//  spritekit-game-ios
//
//  Created by James on 5/15/20.
//  Copyright © 2020 jjlljj. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let asteroid   : UInt32 = 0b1
  static let projectile: UInt32 = 0b10
  static let player: UInt32 = 0b11
}

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
  
  let player = SKSpriteNode(imageNamed: "spaceship.png")
  let label = SKLabelNode(fontNamed: "Chalkduster")
  var asteroidsDestroyed = 0
  var asteroidsHit = 0
  var score = 0
  
  override func didMove(to view: SKView) {
    super.didMove(to:view)
    
    //    let background = SKSpriteNode(imageNamed: "bg")
    //    background.position = CGPoint(x: size.width/2, y: size.height/2)
    //    background.size = CGSize(width: size.width, height: size.height)
    //    addChild(background)
    
    label.text = "Score: \(score)"
    label.fontSize = 16
    label.fontColor = SKColor.white
    label.position = CGPoint(x: 60, y: size.height - 60)
    addChild(label)
    
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self
    
    player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
    player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
    player.physicsBody?.isDynamic = true
    player.physicsBody?.categoryBitMask = PhysicsCategory.player
    player.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
    player.physicsBody?.collisionBitMask = PhysicsCategory.none
    addChild(player)
    
    run(SKAction.repeatForever(
      SKAction.sequence([
        SKAction.run(addAsteroid),
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
  
  func addAsteroid() {
    let asteroid = SKSpriteNode(imageNamed: "asteroid.png")
    asteroid.physicsBody = SKPhysicsBody(rectangleOf: asteroid.size)
    asteroid.physicsBody?.isDynamic = true
    asteroid.physicsBody?.categoryBitMask = PhysicsCategory.asteroid
    asteroid.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
    asteroid.physicsBody?.collisionBitMask = PhysicsCategory.none
    
    let actualX = random(min: asteroid.size.width/2, max: size.width - asteroid.size.width/2)
    
    asteroid.position = CGPoint(x: actualX, y: size.height + asteroid.size.height/2)
    
    addChild(asteroid)
    
    let actualDuration = random(min: CGFloat(5.0), max: CGFloat(8.0))
    
    let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -asteroid.size.height/2), duration: TimeInterval(actualDuration))
    let actionMoveDone = SKAction.removeFromParent()
    asteroid.run(SKAction.sequence([actionMove, actionMoveDone]))
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    
    let touchLocation = touch.location(in: self)
    
    let projectile = SKSpriteNode(color: UIColor.red, size: CGSize(width:3, height:12))
    projectile.position = CGPoint(x: player.position.x, y: player.position.y + player.size.height/2)
    
    
    projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
    projectile.physicsBody?.isDynamic = true
    projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
    projectile.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
    projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
    projectile.physicsBody?.usesPreciseCollisionDetection = true
    
    let offset = touchLocation - projectile.position
    
    if offset.y < 60 { return }
    
    addChild(projectile)
    
    let direction = offset.normalized()
    
    let shootAmount = direction * 1000
    
    let realDestination = shootAmount + projectile.position
    let actionMove = SKAction.move(to: realDestination, duration: 2.5)
    let actionMoveDone = SKAction.removeFromParent()
    projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
  }
  
  func projectileDidCollideWithAsteroid(projectile: SKSpriteNode, asteroid: SKSpriteNode) {
    print("Hit")
    asteroidsDestroyed += 1
    score += 20
    label.text = "Score: \(score)"
    projectile.removeFromParent()
    asteroid.removeFromParent()
  }
  
  func asteroidDidCollideWithPlayer(asteroid: SKSpriteNode, player: SKSpriteNode) {
    print("Player Hit")
    label.text = "Game Over"
    asteroid.removeFromParent()
    player.removeFromParent()
  }
}

extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    } else {
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }
    
    if ((firstBody.categoryBitMask == PhysicsCategory.asteroid) &&
      (secondBody.categoryBitMask == PhysicsCategory.player)) {
      
      if let asteroid = firstBody.node as? SKSpriteNode,
        let player = secondBody.node as? SKSpriteNode {
        return asteroidDidCollideWithPlayer(asteroid: asteroid, player: player)
      }
    }
    
    if ((firstBody.categoryBitMask & PhysicsCategory.asteroid != 0) &&
      (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
      if let asteroid = firstBody.node as? SKSpriteNode,
        let projectile = secondBody.node as? SKSpriteNode {
        projectileDidCollideWithAsteroid(projectile: projectile, asteroid: asteroid)
      }
    }

  }
}
