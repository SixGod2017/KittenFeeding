//
//  RainDropBanner.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class RainDropBanner : SKNode, Touchable {
  typealias RainDrops = (raindrop: SKSpriteNode, lcdRaindrop: SKSpriteNode)

  var rainDropsRainDropsArr = [RainDrops]()

  func pause () {
    for rainTouchableDropSKNode in rainDropsRainDropsArr {
      rainTouchableDropSKNode.raindrop.isPaused = isPaused
      rainTouchableDropSKNode.lcdRaindrop.isPaused = isPaused

      rainTouchableDropSKNode.raindrop.physicsBody?.isDynamic = isPaused
      rainTouchableDropSKNode.raindrop.speed = 0
    }
  }

  public func setup(maskNode : SKNode) {
    for imageNameIndex in 0...23 {
      let index = String(format: "%02d", imageNameIndex)

      let nodechildNodeSKSpriteNode = childNode(withName: "raindrop\(index)") as! SKSpriteNode

      let lcdNodeSKSpriteimageNamedNode = SKSpriteNode(imageNamed: "large_rain_drop")

      rainDropsRainDropsArr.append((raindrop: nodechildNodeSKSpriteNode, lcdRaindrop: lcdNodeSKSpriteimageNamedNode))

      lcdNodeSKSpriteimageNamedNode.anchorPoint = CGPoint(x: 0, y: 1)
      lcdNodeSKSpriteimageNamedNode.position = nodechildNodeSKSpriteNode.position

      maskNode.addChild(lcdNodeSKSpriteimageNamedNode)

      lcdNodeSKSpriteimageNamedNode.zPosition = 100
    }
  }

  public func makeItRain() {
    for rainTouchableDropSKNode in rainDropsRainDropsArr {
      addPhysicsBody(rainDrop: rainTouchableDropSKNode.raindrop)
    }
  }

  private func addPhysicsBody(rainDrop : SKSpriteNode) {
    rainDrop.physicsBody = SKPhysicsBody(texture: rainDrop.texture!, size: rainDrop.size)
    rainDrop.physicsBody?.categoryBitMask = RainDropCategory

    //Makes all of the raindrops fall at different rates
    rainDrop.physicsBody?.linearDamping = CGFloat(arc4random()).truncatingRemainder(dividingBy: 100) / 100
    rainDrop.physicsBody?.mass = CGFloat(arc4random()).truncatingRemainder(dividingBy: 100) / 100
  }

  public func touchBegan(touch: UITouch) {
    for rainTouchableDropSKNode : RainDrops in rainDropsRainDropsArr {
      if rainTouchableDropSKNode.raindrop.contains(touch.location(in: self)) {
        enlargeRaindrop(rainTouchableDropSKNode.raindrop)
        enlargeRaindrop(rainTouchableDropSKNode.lcdRaindrop)
      }
    }
  }

  func enlargeRaindrop(_ raindrop : SKSpriteNode) {
    let oldScaleCGFloatValue = raindrop.xScale

    let newScaleCGFloatValu = min(raindrop.xScale + 0.35, 1)
    //Since we use a 0,1 anchor point, we need to update the position to appear centered
    if oldScaleCGFloatValue != newScaleCGFloatValu {
      raindrop.position.x -= raindrop.size.width / 33

      let scaleRainDropAction = SKAction.group([
        SKAction.moveTo(x: raindrop.position.x - raindrop.size.width / 4, duration: 0.05),
        SKAction.scale(to: newScaleCGFloatValu, duration: 0.050001)
        ])

      raindrop.run(scaleRainDropAction)
    }
  }

  public func touchMoved(touch: UITouch) { }

  public func touchEnded(touch: UITouch) { }

  public func touchCancelled(touch: UITouch) { }

  public func update(size: CGSize) {
    for nodeSKSprlcdRaindropiteNode: RainDrops in rainDropsRainDropsArr {
      nodeSKSprlcdRaindropiteNode.lcdRaindrop.position = nodeSKSprlcdRaindropiteNode.raindrop.position
      nodeSKSprlcdRaindropiteNode.lcdRaindrop.setScale(nodeSKSprlcdRaindropiteNode.raindrop.xScale)
      nodeSKSprlcdRaindropiteNode.lcdRaindrop.position.y += size.height //This fixes anchorpoint madness
      nodeSKSprlcdRaindropiteNode.lcdRaindrop.zRotation = nodeSKSprlcdRaindropiteNode.raindrop.zRotation
    }
  }
}
