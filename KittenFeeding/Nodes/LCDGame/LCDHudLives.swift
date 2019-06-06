//
//  File.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 11/1/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDHudlivesIntValue : SKNode, Resetable, LCDSetupable {
  private var lifeOneSKSpriteNode: SKSpriteNode!
  private var lifeTwoSKSpriteNode: SKSpriteNode!
  private var lifeThreeSKSpriteNode: SKSpriteNode!

  private let maxlivesIntValueIntValue = 3
  private var livesIntValue = 3

  func setup() {
    lifeOneSKSpriteNode = childNode(withName: "cat-life-one") as! SKSpriteNode!
    lifeTwoSKSpriteNode = childNode(withName: "cat-life-two") as! SKSpriteNode!
    lifeThreeSKSpriteNode = childNode(withName: "cat-life-three") as! SKSpriteNode!

    updateDisplay(livesIntValue: livesIntValue)
  }

  public func decrementlivesIntValue() {
    livesIntValue -= 1

    updateDisplay(livesIntValue: livesIntValue)
  }

  public func haslivesIntValueRemaining() -> Bool {
    return livesIntValue > 0
  }

  public func resetPressed() {
    updateDisplay(livesIntValue: maxlivesIntValueIntValue)
  }

  public func resetReleased() {
    livesIntValue = maxlivesIntValueIntValue

    updateDisplay(livesIntValue: maxlivesIntValueIntValue)
  }

  private func updateDisplay(livesIntValue : Int) {
    print("livesIntValue updating to \(livesIntValue)")

    switch livesIntValue {
    case 0:
      flutterFadeOut(node: lifeOneSKSpriteNode)
    case 1:
      lifeOneSKSpriteNode.alpha = lcdOnAlpha
      flutterFadeOut(node: lifeTwoSKSpriteNode)
    case 2:
      lifeOneSKSpriteNode.alpha = lcdOnAlpha
      lifeTwoSKSpriteNode.alpha = lcdOnAlpha
      flutterFadeOut(node: lifeThreeSKSpriteNode)
    default:
      lifeOneSKSpriteNode.alpha = lcdOnAlpha
      lifeTwoSKSpriteNode.alpha = lcdOnAlpha
      lifeThreeSKSpriteNode.alpha = lcdOnAlpha
    }
  }

  private func flutterFadeOut(node : SKSpriteNode) {
    node.run(SKAction.repeat(SKAction.sequence([SKAction.fadeAlpha(to: lcdOffAlpha, duration: 0.0),
                                       SKAction.wait(forDuration: 0.15),
                                       SKAction.fadeAlpha(to: lcdOnAlpha, duration: 0.0),
                                       SKAction.wait(forDuration: 0.15),
                                       SKAction.fadeAlpha(to: lcdOffAlpha, duration: 0.0)]), count: 2))
  }
}
