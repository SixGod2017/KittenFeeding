//
//  TestAlphaButton.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 5/3/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class TextButtonSprite : SKAControlSprite {
  var labelTextButtonSKLabelNode: SKLabelNode!

  init() {
    super.init(texture: nil, color: .clear, size: .zero)
    basicSetting()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    basicSetting()
  }

  private func basicSetting() {
    color = .clear
    labelTextButtonSKLabelNode = SKLabelNode(fontNamed: BASE_FONT_NAME)
    labelTextButtonSKLabelNode.zPosition = zPosition
  }

  func set(text: String, fontSize: CGFloat, autoResize: Bool, fontColor : SKColor = .white) {
    color = .clear
    
    labelTextButtonSKLabelNode.horizontalAlignmentMode = .center
    labelTextButtonSKLabelNode.verticalAlignmentMode = .center
    labelTextButtonSKLabelNode.fontSize = fontSize
    labelTextButtonSKLabelNode.fontColor = fontColor
    labelTextButtonSKLabelNode.text = text

    if autoResize {
      size = CGSize(width: labelTextButtonSKLabelNode.frame.width * 1.5, height: labelTextButtonSKLabelNode.frame.height * 2.5)
    }

    addChild(labelTextButtonSKLabelNode)
  }

  override func updateControl() {
    var actionSKAction: SKAction
    if controlState.contains(.Disabled) {
      actionSKAction = SKAction.scale(to: 0.25, duration: 0.15)
    } else if controlState.contains(.Highlighted) {
      actionSKAction = SKAction.scale(to: 1.1, duration: 0.15)
    } else {
      actionSKAction = SKAction.scale(to: 1, duration: 0.15)
    }

    labelTextButtonSKLabelNode.run(actionSKAction)
  }
}
