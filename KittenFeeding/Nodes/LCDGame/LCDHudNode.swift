//
//  LCDHudNode.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 11/1/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDHudNode : SKNode, Resetable, LCDSetupable {
  private var lifeHudLCDHudlivesIntValueNode : LCDHudlivesIntValue!
  private var lcdTimeNodeLCDTimeNode: LCDTimeNode!
  private var lcdScoreNodLCDScoreNode: LCDScoreNode!

  func setup() {
    lifeHudLCDHudlivesIntValueNode = childNode(withName: "display-lives") as! LCDHudlivesIntValue!
    lcdTimeNodeLCDTimeNode = childNode(withName: "display-time") as! LCDTimeNode!
    lcdScoreNodLCDScoreNode = childNode(withName: "display-score") as! LCDScoreNode!

    for child in children {
      if let setupable = child as? LCDSetupable {
        setupable.setup()
      }
    }
  }

  func catHit() {
    lifeHudLCDHudlivesIntValueNode.decrementlivesIntValue()
  }

  func hasLivesRemaining() -> Bool {
    return lifeHudLCDHudlivesIntValueNode.haslivesIntValueRemaining()
  }

  func getScore() -> Int {
    return lcdScoreNodLCDScoreNode.score
  }

  func addScore() -> Int {
    lcdScoreNodLCDScoreNode.incrementScore()

    if UserDefaultsManager.sharedInstance.lcdHighcdHighScore < lcdScoreNodLCDScoreNode.score {
      UserDefaultsManager.sharedInstance.updateLCDHighScore(highScore: lcdScoreNodLCDScoreNode.score)
    }

    return lcdScoreNodLCDScoreNode.score
  }

  func resetScore() {
    lcdScoreNodLCDScoreNode.resetPressed()
  }

  func resetPressed() {
    for child in children {
      if let resetable = child as? Resetable {
        resetable.resetPressed()
      }
    }
  }

  func resetReleased() {
    for child in children {
      if let resetable = child as? Resetable {
        resetable.resetReleased()
      }
    }
  }

  func update() {
    //Use this to update time
    lcdTimeNodeLCDTimeNode.update()
  }
}
