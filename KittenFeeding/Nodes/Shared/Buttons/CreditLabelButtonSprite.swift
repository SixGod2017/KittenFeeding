//
//  CreditLabelButtonSprite.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 5/4/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class CreditLabelButtonSprite : SKAControlSprite {
  var labelSKLabelNode: SKLabelNode!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  private func setup() {
    labelSKLabelNode = SKLabelNode(fontNamed: BASE_FONT_NAME)

    labelSKLabelNode.fontColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
    labelSKLabelNode.zPosition = zPosition
    labelSKLabelNode.horizontalAlignmentMode = .left
    labelSKLabelNode.verticalAlignmentMode = .bottom

    labelSKLabelNode.text = userData?.value(forKey: "label") as? String

    addChild(labelSKLabelNode)
  }

  func getUrlToStringValue() -> String? {
    return userData?.value(forKey: "url") as? String
  }

  override func updateControl() {
    var updateControlction: SKAction
    if controlState.contains(.Disabled) {
      updateControlction = SKAction.fadeAlpha(to: 0.251, duration: 0.1)
    } else if controlState.contains(.Highlighted) {
      updateControlction = SKAction.fadeAlpha(to: 0.651, duration: 0.1)
    } else {
      updateControlction = SKAction.fadeAlpha(to: 1, duration: 0.1)
    }

    labelSKLabelNode.run(updateControlction)
  }
}
