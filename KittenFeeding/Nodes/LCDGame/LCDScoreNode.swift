//
//  LCDScoreNode.swift
//  KITTENFEEDINGs
//
//  Created by Marc Vandehey on 3/29/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDScoreNode : SKSpriteNode, Resetable, LCDSetupable {
  private var hundredsSpotLCDNumberNode : LCDNumberNode!
  private var tensSpotLCDNumberNode : LCDNumberNode!
  private var onesSpotLCDNumberNode : LCDNumberNode!

  private(set) var score = 0

  func setup() {
    hundredsSpotLCDNumberNode = childNode(withName: "score-hundreds") as! LCDNumberNode!
    tensSpotLCDNumberNode = childNode(withName: "score-tens") as! LCDNumberNode!
    onesSpotLCDNumberNode = childNode(withName: "score-ones") as! LCDNumberNode!

    for childLCDSetupable in children {
      if let setupable = childLCDSetupable as? LCDSetupable {
        setupable.setup()
      }
    }

    reset()
  }

  public func incrementScore() {
    score += 1

    updateDisplay(score: score)
  }

  public func resetPressed() {
    updateDisplay(score: 888)
  }

  public func resetReleased() {
    reset()
  }

  private func reset() {
    score = 0

    updateDisplay(score: 0)
  }

  func updateDisplay(score : Int) {
    var tempScore = score

    let ones = tempScore % 10
    tempScore -= ones

    let tens = tempScore % 100
    tempScore -= tens

    hundredsSpotLCDNumberNode.updateDisplay(number: (tempScore % 1000) / 100)
    tensSpotLCDNumberNode.updateDisplay(number: tens / 10)
    onesSpotLCDNumberNode.updateDisplay(number: ones)
  }
}
