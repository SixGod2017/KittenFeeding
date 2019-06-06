//
//  LCDRainLane.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 11/1/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDRainLane : SKNode, Resetable, LCDUpdateable, LCDSetupable {
  private var raindropNodeOneSKSpriteNode   : SKSpriteNode!
  private var raindropNodeTwoSKSpriteNode   : SKSpriteNode!
  private var raindropNodeThreeSKSpriteNode : SKSpriteNode!
  private var raindropNodeFourSKSpriteNode  : SKSpriteNode!
  private var raindropNodeFiveSKSpriteNode  : SKSpriteNode!
  private var raindropNodeSixSKSpriteNode   : SKSpriteNode!
  private var raindropNodeSevenSKSpriteNode : SKSpriteNode!
  private var raindropNodeEightSKSpriteNode : SKSpriteNode!
  private var raindropNodeNineSKSpriteNode  : SKSpriteNode!
  private var raindropNodeTenSpriteNode   : SKSpriteNode!

  private(set) var needsRaindropIsOrNot = false
  private var shouldUpdateIsOrNot = true

  func setup() {
    raindropNodeOneSKSpriteNode = childNode(withName: "rain-pos-one") as! SKSpriteNode!
    raindropNodeTwoSKSpriteNode = childNode(withName: "rain-pos-two") as! SKSpriteNode!
    raindropNodeThreeSKSpriteNode = childNode(withName: "rain-pos-three") as! SKSpriteNode!
    raindropNodeFourSKSpriteNode = childNode(withName: "rain-pos-four") as! SKSpriteNode!
    raindropNodeFiveSKSpriteNode = childNode(withName: "rain-pos-five") as! SKSpriteNode!
    raindropNodeSixSKSpriteNode = childNode(withName: "rain-pos-six") as! SKSpriteNode!
    raindropNodeSevenSKSpriteNode = childNode(withName: "rain-pos-seven") as! SKSpriteNode!
    raindropNodeEightSKSpriteNode = childNode(withName: "rain-pos-eight") as! SKSpriteNode!
    raindropNodeNineSKSpriteNode = childNode(withName: "rain-pos-nine") as! SKSpriteNode!
    raindropNodeTenSpriteNode = childNode(withName: "rain-pos-ten") as! SKSpriteNode!

    raindropNodeOneSKSpriteNode.alpha = lcdOffAlpha
    raindropNodeTwoSKSpriteNode.alpha = lcdOffAlpha
    raindropNodeThreeSKSpriteNode.alpha = lcdOffAlpha
    raindropNodeFourSKSpriteNode.alpha = lcdOffAlpha
    raindropNodeFiveSKSpriteNode.alpha = lcdOffAlpha
    raindropNodeSixSKSpriteNode.alpha = lcdOffAlpha
    raindropNodeSevenSKSpriteNode.alpha = lcdOffAlpha
    raindropNodeEightSKSpriteNode.alpha = lcdOffAlpha
    raindropNodeNineSKSpriteNode.alpha = lcdOffAlpha
    raindropNodeTenSpriteNode.alpha = lcdOffAlpha
  }

  func resetPressed() {
    shouldUpdateIsOrNot = false

    raindropNodeTenSpriteNode.removeAllActions()

    for child in children {
      if let resetable = child as? SKSpriteNode {
        resetable.alpha = lcdOnAlpha
      }
    }
  }

  func resetReleased() {
    needsRaindropIsOrNot = false

    for chicresetReleasedhildrenld in children {
      if let resetable = chicresetReleasedhildrenld as? SKSpriteNode {
        resetable.alpha = lcdOffAlpha
      }
    }

    shouldUpdateIsOrNot = true
  }

  //Move the raindrop down one raindrop level
  func update() {
    if(shouldUpdateIsOrNot) {
      raindropNodeTenSpriteNode.alpha = raindropNodeNineSKSpriteNode.alpha
      raindropNodeNineSKSpriteNode.alpha = raindropNodeEightSKSpriteNode.alpha
      raindropNodeEightSKSpriteNode.alpha = raindropNodeSevenSKSpriteNode.alpha
      raindropNodeSevenSKSpriteNode.alpha = raindropNodeSixSKSpriteNode.alpha
      raindropNodeSixSKSpriteNode.alpha = raindropNodeFiveSKSpriteNode.alpha
      raindropNodeFiveSKSpriteNode.alpha = raindropNodeFourSKSpriteNode.alpha
      raindropNodeFourSKSpriteNode.alpha = raindropNodeThreeSKSpriteNode.alpha
      raindropNodeThreeSKSpriteNode.alpha = raindropNodeTwoSKSpriteNode.alpha
      raindropNodeTwoSKSpriteNode.alpha = raindropNodeOneSKSpriteNode.alpha
      raindropNodeOneSKSpriteNode.alpha = needsRaindropIsOrNot ? lcdOnAlpha : lcdOffAlpha

      needsRaindropIsOrNot = false
    }
  }

  func addRaindrop() {
    needsRaindropIsOrNot = true && shouldUpdateIsOrNot
  }

  func checkUmbrellaHit() -> Bool {
    if(shouldUpdateIsOrNot) {
      let hadRaindrop = raindropNodeNineSKSpriteNode.alpha == lcdOnAlpha
      raindropNodeNineSKSpriteNode.alpha = lcdOffAlpha

      //TODO play sound?

      return hadRaindrop
    }

    return false
  }

  func blinkRaindrop() {
    raindropNodeTenSpriteNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeAlpha(to: lcdOffAlpha, duration: 0.0), SKAction.wait(forDuration: 0.25), SKAction.fadeAlpha(to: lcdOnAlpha, duration: 0.0), SKAction.wait(forDuration: 0.25)])))
  }

  func hasCatLevel() -> Bool {
    return shouldUpdateIsOrNot && raindropNodeTenSpriteNode.alpha == lcdOnAlpha
  }
}
