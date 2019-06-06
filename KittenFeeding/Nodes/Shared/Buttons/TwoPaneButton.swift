//
//  TwoPaneButton.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 11/2/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class TwoPaneButton : SKAControlSprite {

  private var foregroundPaneSKSpriteNode: SKSpriteNode!
  private var backgroundPaneSKSpriteNode: SKSpriteNode!
  private var labelSKLabelNode: SKLabelNode!
  private var zeroPositionPoint = CGPoint()
  private var buttonElevationCGFloat: CGFloat = 10

  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
  }

  convenience init(text: String, textSize: CGFloat, size : CGSize) {
    self.init(texture: nil, color: .clear, size: size)

    setupConfiguration(text: text, fontSize: textSize)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    color = .clear

    if let textStingValue = userData?.value(forKey: "text") as? String, let fontSizeIntValue = userData?.value(forKey: "textSize") as? Int {
      setupConfiguration(text: textStingValue, fontSize: CGFloat(fontSizeIntValue))
    }
  }

  var elevationCGFloat: CGFloat {
    set {
      buttonElevationCGFloat = newValue
      updateElevation(newElevation: buttonElevationCGFloat)
    }
    get {
      return buttonElevationCGFloat
    }
  }

  func updateElevation(newElevation : CGFloat) {
    zeroPositionPoint = CGPoint(x: -elevationCGFloat, y: -elevationCGFloat)
    backgroundPaneSKSpriteNode.position = zeroPositionPoint

    var buttonSize = size
    buttonSize.height -= elevationCGFloat
    buttonSize.width -= elevationCGFloat

    backgroundPaneSKSpriteNode.size = buttonSize
    foregroundPaneSKSpriteNode.size = buttonSize

    if anchorPoint == CGPoint(x: 0, y: 1) {
      labelSKLabelNode.position = CGPoint(x: buttonSize.width / 2, y: -buttonSize.height / 2)
    }
  }

  func setupConfiguration(text: String, fontSize: CGFloat) {
    zeroPositionPoint = CGPoint.zero

    anchorPoint = CGPoint(x: 0, y: 1)

    self.color = SKColor.clear

    if backgroundPaneSKSpriteNode == nil {
      backgroundPaneSKSpriteNode = SKSpriteNode(color: SKColor(red:0.79, green:0.76, blue:0.37, alpha:1.0), size: size)
      backgroundPaneSKSpriteNode.position = zeroPositionPoint
      backgroundPaneSKSpriteNode.anchorPoint = anchorPoint

      addChild(backgroundPaneSKSpriteNode)
    }

    if foregroundPaneSKSpriteNode == nil {
      foregroundPaneSKSpriteNode = SKSpriteNode(color: SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0), size: size)
      foregroundPaneSKSpriteNode.anchorPoint = anchorPoint

      addChild(foregroundPaneSKSpriteNode)
    }

    if labelSKLabelNode == nil {
      labelSKLabelNode = SKLabelNode(fontNamed: BASE_FONT_NAME)
      labelSKLabelNode.fontSize = fontSize
      labelSKLabelNode.fontColor = SKColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
      labelSKLabelNode.horizontalAlignmentMode = .center
      labelSKLabelNode.verticalAlignmentMode = .center

      foregroundPaneSKSpriteNode.addChild(labelSKLabelNode)
    }

    labelSKLabelNode.text = text

    if let sksElevation = userData?.value(forKey: "elevation") as? Int {
      elevationCGFloat = CGFloat(sksElevation)
      updateElevation(newElevation: CGFloat(sksElevation))
    } else {
      elevationCGFloat = 10
    }

    addTarget(self, selector: #selector(clickSound), forControlEvents: .TouchUpInside)
  }

    @objc func clickSound() {
    AVAudioPlayerSoundManager.playButtonPlayButtonClick(node: self)
  }

  let moveKeyMoving_the_button_yay = "moving_the_button_yay!"

  func moveTo(y: CGFloat, duration: TimeInterval = 0.5, delay: TimeInterval = 0.0) {
    runMoveAction(horizontally: true, positiveMovement:  y > position.y, point: CGPoint(x: position.x, y: y), duration : duration, delay: delay)
  }

  func moveTo(x: CGFloat, duration : TimeInterval = 0.5, delay: TimeInterval = 0.0) {
    runMoveAction(horizontally: false, positiveMovement: x > position.x, point: CGPoint(x: x, y: position.y), duration : duration, delay: delay)
  }

  private func runMoveAction(horizontally : Bool, positiveMovement : Bool, point : CGPoint, duration : TimeInterval, delay : TimeInterval) {
      removeAction(forKey: moveKeyMoving_the_button_yay)
    
      let endDoubleValue = duration * 0.1

      var startAmountCGFloat: CGFloat = 0
      var overshootAmountCGFloat: CGFloat = 0
      var settleAmountCGFloat: CGFloat = 0

      if positiveMovement {
        print("moving up")

        startAmountCGFloat = -elevationCGFloat
        overshootAmountCGFloat = elevationCGFloat * 1.5
        settleAmountCGFloat = -elevationCGFloat * 0.5
      } else {
        print("moving down")

        startAmountCGFloat = elevationCGFloat * 1.5
        overshootAmountCGFloat = -elevationCGFloat * 2
        settleAmountCGFloat = elevationCGFloat * 0.5
      }

      var startActionSKAction: SKAction
      var waitActionSKAction: SKAction
      var overshootActionSKAction: SKAction
      var settleActionSKAction: SKAction
      let delayActionSKAction = SKAction.wait(forDuration: delay)
      let moveActionSKAction = SKAction.move(to: point, duration: duration)

      if horizontally {
        startActionSKAction = SKAction.moveBy(x: 0, y: startAmountCGFloat, duration: endDoubleValue)
        overshootActionSKAction = SKAction.moveBy(x: 0, y: overshootAmountCGFloat, duration: endDoubleValue * 2)
        settleActionSKAction = SKAction.moveBy(x: 0, y: settleAmountCGFloat, duration: endDoubleValue * 2)
      } else {
        startActionSKAction = SKAction.moveBy(x: startAmountCGFloat, y: 0, duration: endDoubleValue)
        overshootActionSKAction = SKAction.moveBy(x: overshootAmountCGFloat, y: 0, duration: endDoubleValue * 2)
        settleActionSKAction = SKAction.moveBy(x: settleAmountCGFloat, y: 0, duration: endDoubleValue * 2)
      }

      waitActionSKAction = SKAction.wait(forDuration: duration - endDoubleValue * 2)

      startActionSKAction.timingMode = .easeIn
      overshootActionSKAction.timingMode = .easeOut
      settleActionSKAction.timingMode = .easeInEaseOut
      moveActionSKAction.timingMode = .easeInEaseOut

      backgroundPaneSKSpriteNode.run(SKAction.sequence([
        delayActionSKAction, startActionSKAction, waitActionSKAction, overshootActionSKAction, settleActionSKAction
        ]))

      run(SKAction.sequence([delayActionSKAction, moveActionSKAction]), withKey: moveKeyMoving_the_button_yay)
  }

  override func updateControl() {
    if controlState.contains(.Highlighted) {
      foregroundPaneSKSpriteNode.run(SKAction.move(to: zeroPositionPoint, duration: 0.05))
    } else if controlState.contains(.Normal) {
      foregroundPaneSKSpriteNode.run(SKAction.move(to: CGPoint.zero, duration: 0.05))
    }
  }

  override var zPosition: CGFloat {
    didSet {
      if foregroundPaneSKSpriteNode != nil {
        foregroundPaneSKSpriteNode.zPosition = zPosition + 1
        labelSKLabelNode.zPosition = zPosition + 2
      }
    }
  }
}

