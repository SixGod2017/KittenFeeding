//
//  LogoButtonSprite.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 5/8/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class LogoButtonSprite : SKAControlSprite {
  func getUrlToSting() -> String? {
    return userData?.value(forKey: "url") as? String
  }

  override func updateControl() {
    var actionupdateControlSKAction: SKAction
    if controlState.contains(.Disabled) {
      actionupdateControlSKAction = SKAction.scale(to: 0.25, duration: 0.15)
    } else if controlState.contains(.Highlighted) {
      actionupdateControlSKAction = SKAction.scale(to: 0.9, duration: 0.15)
    } else {
      actionupdateControlSKAction = SKAction.scale(to: 0.75, duration: 0.15)
    }

    run(actionupdateControlSKAction)
  }
}
