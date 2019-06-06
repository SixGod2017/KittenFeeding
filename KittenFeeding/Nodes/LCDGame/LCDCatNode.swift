//
//  LCDCatNode.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 3/29/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDCatNode : SKNode, Resetable, LCDSetupable {
  private var catLeftSKSpriteNode: SKSpriteNode!
  private var catRightSKSpriteNode: SKSpriteNode!
  private var backgroundSpriteSKSpriteNode: SKSpriteNode!

  func setup() {
    backgroundSpriteSKSpriteNode = childNode(withName: "cat-background") as! SKSpriteNode!
    catLeftSKSpriteNode = childNode(withName: "cat-left") as! SKSpriteNode!
    catRightSKSpriteNode = childNode(withName: "cat-right") as! SKSpriteNode!

    reset()
  }

  func resetPressed() {
    catLeftSKSpriteNode.alpha = 0
    catRightSKSpriteNode.alpha = 0

    backgroundSpriteSKSpriteNode.alpha = lcdOnAlpha
  }

  func resetReleased() {
    reset()
  }

  private func reset() {
    backgroundSpriteSKSpriteNode.alpha = lcdOffAlpha
    catLeftSKSpriteNode.alpha = 0
    catRightSKSpriteNode.alpha = 0

    catLeftSKSpriteNode.removeAllActions()
    catRightSKSpriteNode.removeAllActions()
  }

  func update(hasCat : Bool, facingLeft : Bool) {
    if hasCat {
      catLeftSKSpriteNode.alpha = facingLeft ? lcdOnAlpha : 0
      catRightSKSpriteNode.alpha = !facingLeft ? lcdOnAlpha : 0
    } else {
      catLeftSKSpriteNode.alpha = 0
      catRightSKSpriteNode.alpha = 0
    }
  }
}
