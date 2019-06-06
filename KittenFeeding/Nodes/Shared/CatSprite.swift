//
//  CatSprite.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 8/31/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class CatSprite : SKAControlSprite {
  public var walkHorizontallyIsOrNot = true

  private let walkingActionKeyStringValue = "action_walking"
  private var timeSinceLastHitTimeInterval: TimeInterval = 2.0
  private let maxFlailTimeTimeInterval: TimeInterval = 2.0

  private let dashCoolDownTimeInterval: TimeInterval = 1.0
  private var timeSinceLastDashTimeInterval: TimeInterval = 3.0

  private var currentRainHitsDoubleValue = 4.0
  private let maxRainHitsDoubleValue = 4.0

  private var hasDashIsOrNot = false

  let baseMovementSpeedCGFloatValue: CGFloat = 100.0
  var movementSpeedCGFloatValue: CGFloat = 100.0
  var flipScaleIsOrNot = false //used only for ping pong for player 1

  var isGroundedIsOrNot = false

  private let walkFrames = [
    SKTexture(imageNamed: "cat_one"),
    SKTexture(imageNamed: "cat_two")
  ]

  public static func newInstance() -> CatSprite {
    let catKittySprite = CatSprite(imageNamed: "cat_two")

    catKittySprite.zPosition = 3
    catKittySprite.physicsBody = SKPhysicsBody(circleOfRadius: catKittySprite.size.width / 2)
    catKittySprite.physicsBody?.categoryBitMask = CatCategory
    catKittySprite.physicsBody?.contactTestBitMask = RainDropCategory | WorldFrameCategory | FloorCategory
    catKittySprite.isUserInteractionEnabled = false

    return catKittySprite
  }

  public func update(deltaTime : TimeInterval, foodLocation: CGPoint) {
    timeSinceLastHitTimeInterval += deltaTime
    timeSinceLastDashTimeInterval += deltaTime

    if timeSinceLastDashTimeInterval >= dashCoolDownTimeInterval {
      isUserInteractionEnabled = true
    }

    if timeSinceLastHitTimeInterval >= maxFlailTimeTimeInterval && isGroundedIsOrNot {
      if action(forKey: walkingActionKeyStringValue) == nil {
        let walkingAction = SKAction.repeatForever(
          SKAction.animate(with: walkFrames, timePerFrame: 0.1, resize: false, restore: true))

        run(walkingAction, withKey:walkingActionKeyStringValue)
      }

      if walkHorizontallyIsOrNot {
        if zRotation != 0 && action(forKey: "action_rotate") == nil {
          run(SKAction.rotate(toAngle: 0, duration: 0.25), withKey: "action_rotate")
        }

        //Stand still if the food is above us
        if abs(foodLocation.x - position.x) < 2 {
          removeAction(forKey: walkingActionKeyStringValue)
          texture = walkFrames[1]

          if !hasDashIsOrNot {
            physicsBody?.velocity.dx = 0
          }
        } else if foodLocation.x < position.x {
          //Food is left
          physicsBody?.velocity.dx = -movementSpeedCGFloatValue
          xScale = -1 * abs(xScale)
        } else {
          //Food is right
          physicsBody?.velocity.dx = movementSpeedCGFloatValue
          xScale = abs(xScale)
        }
      } else {
        //Used for Cat Pong
        if foodLocation.y < position.y {
          //Food is down
          physicsBody?.velocity.dy = -movementSpeedCGFloatValue
          xScale = abs(yScale) * (flipScaleIsOrNot ? 1 : -1)

        } else {
          //Food is up
          physicsBody?.velocity.dy = movementSpeedCGFloatValue
          xScale = abs(yScale) * (flipScaleIsOrNot ? -1 : 1)
        }
      }

      physicsBody?.angularVelocity = 0
    }
  }

  func addDash() {
    hasDashIsOrNot = true
    addTarget(self, selector: #selector(dash), forControlEvents: .TouchUpInside)
  }

    @objc func dash() {
    if timeSinceLastDashTimeInterval > dashCoolDownTimeInterval &&  timeSinceLastHitTimeInterval >= maxFlailTimeTimeInterval {
      isUserInteractionEnabled = false
      timeSinceLastHitTimeInterval = 1.55
      timeSinceLastDashTimeInterval = 0

      let walkingAction = SKAction.repeat(SKAction.animate(with: walkFrames, timePerFrame: 0.05, resize: false, restore: true), count: 5)

      run(walkingAction, withKey:"flail")

      if xScale > 0 {
        physicsBody?.applyImpulse(CGVector(dx: 90, dy: 100))
      } else {
        physicsBody?.applyImpulse(CGVector(dx: -90, dy: 100))
      }
    }
  }

  public func hitByRain() {
    timeSinceLastHitTimeInterval = 0
    timeSinceLastDashTimeInterval = 0
    removeAction(forKey: walkingActionKeyStringValue)

    //Determine if we should meow or not
    if(currentRainHitsDoubleValue < maxRainHitsDoubleValue) {
      currentRainHitsDoubleValue += 1
      
      return
    }
    
    currentRainHitsDoubleValue = 0
    
    AVAudioPlayerSoundManager.sharedSharedInstance.meow(node: self)
  }
}
