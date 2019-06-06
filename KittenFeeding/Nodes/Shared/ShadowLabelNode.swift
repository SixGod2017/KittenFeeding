//
//  ShadowLabelNode.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 9/19/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class ShadowLabelNode : SKNode {

  private var shadowTextNodeSKLabelNode: SKLabelNode!
  private var textNodeSKLabelNode: SKLabelNode!

  init(fontNamed: String) {
    super.init()

    setup(fontNamed: fontNamed)
  }

  func setup(fontNamed: String) {
    textNodeSKLabelNode = SKLabelNode(fontNamed: fontNamed)
    shadowTextNodeSKLabelNode = SKLabelNode(fontNamed: fontNamed)

    textNodeSKLabelNode.zPosition = 10
    shadowTextNodeSKLabelNode.zPosition = 0

    textNodeSKLabelNode.position = CGPoint()
    shadowTextNodeSKLabelNode.position = CGPoint(x: -1, y: -6)

    textNodeSKLabelNode.fontColor = SKColor.white
    shadowTextNodeSKLabelNode.fontColor = SKColor.black
    shadowTextNodeSKLabelNode.alpha = 0.2

    addChild(textNodeSKLabelNode)
    addChild(shadowTextNodeSKLabelNode)
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    setup(fontNamed: BASE_FONT_NAME)
    let labelText = userData?.value(forKey: "text") as? String
    let textSize = CGFloat(userData?.value(forKey: "textSize") as? Int ?? 100)
    textNodeSKLabelNode.text = labelText
    shadowTextNodeSKLabelNode.text = labelText

    textNodeSKLabelNode.fontSize = textSize
    shadowTextNodeSKLabelNode.fontSize = textSize
  }

  public override var zPosition: CGFloat {
    didSet {
      if textNodeSKLabelNode != nil {
        textNodeSKLabelNode.zPosition = zPosition
        shadowTextNodeSKLabelNode.zPosition = zPosition - 1
      }
    }
  }

  public var fontSize : CGFloat = 32 {
    didSet {
      textNodeSKLabelNode.fontSize = fontSize
      shadowTextNodeSKLabelNode.fontSize = fontSize

      if fontSize < 80 {
        shadowTextNodeSKLabelNode.position = CGPoint(x: -1, y: -3)
      } else {
        shadowTextNodeSKLabelNode.position = CGPoint(x: -1, y: -6)
      }
    }
  }

  public var text: String? {
    didSet {
      textNodeSKLabelNode.text = text
      shadowTextNodeSKLabelNode.text = text
    }
  }

  public var horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center {
    didSet {
      textNodeSKLabelNode.horizontalAlignmentMode = horizontalAlignmentMode
      shadowTextNodeSKLabelNode.horizontalAlignmentMode = horizontalAlignmentMode
    }
  }

  public func getLCDVersion() -> SKLabelNode {
    let newNodeSKLabelNode = SKLabelNode(fontNamed: textNodeSKLabelNode.fontName)
    newNodeSKLabelNode.text = textNodeSKLabelNode.text
    newNodeSKLabelNode.color = .black
    newNodeSKLabelNode.fontSize = textNodeSKLabelNode.fontSize
    newNodeSKLabelNode.horizontalAlignmentMode = textNodeSKLabelNode.horizontalAlignmentMode
    newNodeSKLabelNode.verticalAlignmentMode = textNodeSKLabelNode.verticalAlignmentMode
    newNodeSKLabelNode.position = position
    
    return newNodeSKLabelNode
  }
}
