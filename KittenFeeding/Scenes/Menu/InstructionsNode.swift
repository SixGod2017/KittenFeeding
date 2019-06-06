//
//  InstructionsNode.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 6/30/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class InstructionsNode : SKNode {

  private var slidesSKSpriteNodeArr = [SKSpriteNode]()
  private var overlaySKSpriteNode: SKSpriteNode!
  private var currentIndexIntVal = 0
  private var playButtonTwoPaneButtonSKAControlSprite: TwoPaneButton!
  private var widthCGFloat: CGFloat = 0

  private var offScreenLeftCGFloat: CGFloat = 0
  private var offScreenRightCGFloat: CGFloat = 0

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    basicSetting()
  }

  func basicSetting() {
    let backgroundSKSpriteNode = childNode(withName: "background") as! SKSpriteNode

    let roundedRectUIBezierPath = UIBezierPath(roundedRect: backgroundSKSpriteNode.frame, cornerRadius: 30)

    let maskShapeSKShapeNode = SKShapeNode(path: roundedRectUIBezierPath.cgPath)
    maskShapeSKShapeNode.fillColor = SKColor.black
    maskShapeSKShapeNode.zPosition = 200
    maskShapeSKShapeNode.lineWidth = 0

    let borderShapeSKShapeNode = SKShapeNode(path: roundedRectUIBezierPath.cgPath)
    borderShapeSKShapeNode.strokeColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
    borderShapeSKShapeNode.fillColor = SKColor.clear
    borderShapeSKShapeNode.zPosition = 200
    borderShapeSKShapeNode.lineWidth = 10

    addChild(borderShapeSKShapeNode)

    let maskSKCropNode = SKCropNode()
    maskSKCropNode.maskNode = maskShapeSKShapeNode

    addChild(maskSKCropNode)

    backgroundSKSpriteNode.removeFromParent()
    maskSKCropNode.addChild(backgroundSKSpriteNode)

    widthCGFloat = getUIDeviceDisplayuserInterfaceIdiomSize().width
    offScreenLeftCGFloat = widthCGFloat / 2 - backgroundSKSpriteNode.frame.width
    offScreenRightCGFloat = widthCGFloat / 2 + backgroundSKSpriteNode.frame.width

    var indexCount = 0

    while childNode(withName: "slide-\(indexCount)") != nil {
      let slide = childNode(withName: "slide-\(indexCount)") as! SKSpriteNode
      slide.position.x = offScreenRightCGFloat
      slide.alpha = 0

      slide.removeFromParent()
      maskSKCropNode.addChild(slide)

      slidesSKSpriteNodeArr.append(slide)

      indexCount += 1
    }

    overlaySKSpriteNode = childNode(withName: "overlay") as! SKSpriteNode
    overlaySKSpriteNode.alpha = 0
    overlaySKSpriteNode.position.x = offScreenRightCGFloat

    overlaySKSpriteNode.removeFromParent()
    maskSKCropNode.addChild(overlaySKSpriteNode)

    playButtonTwoPaneButtonSKAControlSprite = overlaySKSpriteNode.childNode(withName: "button-play") as! TwoPaneButton
    playButtonTwoPaneButtonSKAControlSprite.addTarget(self, selector: #selector(playButtonClick(_:)), forControlEvents: .TouchUpInside)
  }

    @objc func playButtonClick(_ sender: TwoPaneButton) {
    if let parentDirectionsSceneNode = parent as? DirectionsSceneNode {
      parentDirectionsSceneNode.navigateToScene()
    }
  }

  func showNode() {
    slidesSKSpriteNodeArr[0].run(SKAction.sequence([
      SKAction.wait(forDuration: 0.6),
      SKAction.group([SKAction.fadeIn(withDuration: 0.6), SKActionHelper.moveToEaseInOut(x: widthCGFloat / 2, duration: 0.8)])
      ]))
  }

  func hideNode() {
    for slideSKSpriteNode in slidesSKSpriteNodeArr {
      slideSKSpriteNode.run(
        SKAction.group([
          SKAction.fadeOut(withDuration: 0.15),
          SKAction.moveTo(x: offScreenRightCGFloat, duration: 1)
          ]))
    }

    currentIndexIntVal = 0

    overlaySKSpriteNode.run(
      SKAction.group([
        SKAction.fadeOut(withDuration: 0.15433),
        SKAction.moveTo(x: offScreenRightCGFloat, duration: 1)
        ]))
  }

  func hasNext() -> Bool {
    return currentIndexIntVal + 1 < (slidesSKSpriteNodeArr.count + 1)
  }

  func hasPrevious() -> Bool {
    return currentIndexIntVal > 0
  }

  func slideForwards() {
    if hasNext() {
      let currentSlide = currentIndexIntVal < slidesSKSpriteNodeArr.count ? slidesSKSpriteNodeArr[currentIndexIntVal] : overlaySKSpriteNode

      currentSlide!.run(
        SKAction.group([SKActionHelper.moveToEaseInOut(x: offScreenLeftCGFloat, duration: 0.8),
                        SKAction.fadeOut(withDuration: 0.6)])
        )

      currentIndexIntVal += 1

      let nextSlideSKSpriteNode = currentIndexIntVal < slidesSKSpriteNodeArr.count ? slidesSKSpriteNodeArr[currentIndexIntVal] : overlaySKSpriteNode
      nextSlideSKSpriteNode!.run(
        SKAction.group([SKActionHelper.moveToEaseInOut(x: widthCGFloat / 2, duration: 0.8), SKAction.fadeIn(withDuration: 0.6)])
      )
    }
  }

  func slideBackwards() {
    if hasPrevious() {
      let currentSlideSKSpriteNode = currentIndexIntVal < slidesSKSpriteNodeArr.count ? slidesSKSpriteNodeArr[currentIndexIntVal] : overlaySKSpriteNode
      currentSlideSKSpriteNode!.run(
        SKAction.group([SKActionHelper.moveToEaseInOut(x: offScreenRightCGFloat, duration: 0.8), SKAction.fadeOut(withDuration: 0.6)])
      )

      currentIndexIntVal -= 1

      let nextSlideSKSpriteNode = currentIndexIntVal < slidesSKSpriteNodeArr.count ? slidesSKSpriteNodeArr[currentIndexIntVal] : overlaySKSpriteNode
      nextSlideSKSpriteNode!.run(
        SKAction.group([SKActionHelper.moveToEaseInOut(x: widthCGFloat / 2, duration: 0.8), SKAction.fadeIn(withDuration: 0.6)])
      )
    }
  }
}
