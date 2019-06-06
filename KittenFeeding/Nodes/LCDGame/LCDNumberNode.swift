//bottomRightVerticalBarpriteNode
//  LCDNumberNode.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 3/29/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDNumberNode : SKSpriteNode, LCDSetupable {

  private var topHorizontalBarSKSpriteNode : SKSpriteNode!
  private var middleHorizontalBarSKSpriteNode : SKSpriteNode!
  private var bottomHorizontalBarrSKSpriteNode : SKSpriteNode!

  private var topLeftVerticalBarBarrSKSpriteNode : SKSpriteNode!
  private var topRightVerticalBarKSpriteNode : SKSpriteNode!
  private var bottomRightVerticalBarpriteNodepriteNode : SKSpriteNode!
  private var bottomRightVerticalBar : SKSpriteNode!

  func setup() {
    //Clear the editor color
    color = SKColor.clear

    let horizontalBar = SKTexture(imageNamed: "lcd-horizontal-section")
    let verticalBar = SKTexture(imageNamed: "lcd-vertical-section")

    topHorizontalBarSKSpriteNode = SKSpriteNode(texture: horizontalBar)
    middleHorizontalBarSKSpriteNode = SKSpriteNode(texture: horizontalBar)
    bottomHorizontalBarrSKSpriteNode = SKSpriteNode(texture: horizontalBar)

    topLeftVerticalBarBarrSKSpriteNode = SKSpriteNode(texture: verticalBar)
    topRightVerticalBarKSpriteNode = SKSpriteNode(texture: verticalBar)
    bottomRightVerticalBarpriteNodepriteNode = SKSpriteNode(texture: verticalBar)
    bottomRightVerticalBar = SKSpriteNode(texture: verticalBar)

    let horizontalBarHeight = topHorizontalBarSKSpriteNode.size.height
    let verticalBarHeight = topLeftVerticalBarBarrSKSpriteNode.size.height
    let horizontalBarWidth = topHorizontalBarSKSpriteNode.size.width

    let originX = size.width / 2

    topHorizontalBarSKSpriteNode.position = CGPoint(x: originX, y: -horizontalBarHeight * 0.5)

    topLeftVerticalBarBarrSKSpriteNode.position = CGPoint(x: originX - horizontalBarWidth * 0.5,
                                          y: -horizontalBarHeight * 0.75 - verticalBarHeight * 0.5)
    topRightVerticalBarKSpriteNode.position = CGPoint(x: originX + horizontalBarWidth * 0.5,
                                           y:topLeftVerticalBarBarrSKSpriteNode.position.y)
    middleHorizontalBarSKSpriteNode.position = CGPoint(x: originX,
                                           y: -horizontalBarHeight * 0.75 - verticalBarHeight)
    bottomRightVerticalBarpriteNodepriteNode.position = CGPoint(x: originX - horizontalBarWidth * 0.5,
                                             y: middleHorizontalBarSKSpriteNode.position.y - horizontalBarHeight * 1.5 - horizontalBarHeight * 0.5)
    bottomRightVerticalBar.position = CGPoint(x: originX + horizontalBarWidth * 0.5,
                                              y:bottomRightVerticalBarpriteNodepriteNode.position.y)
    bottomHorizontalBarrSKSpriteNode.position = CGPoint(x: originX,
                                           y: bottomRightVerticalBar.position.y - verticalBarHeight * 0.5)

    addChild(topHorizontalBarSKSpriteNode)
    addChild(middleHorizontalBarSKSpriteNode)
    addChild(bottomHorizontalBarrSKSpriteNode)

    addChild(topLeftVerticalBarBarrSKSpriteNode)
    addChild(topRightVerticalBarKSpriteNode)
    addChild(bottomRightVerticalBarpriteNodepriteNode)
    addChild(bottomRightVerticalBar)
  }

  func updateDisplay(number : Int) {
    switch number {
    case 0:
      topHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      middleHorizontalBarSKSpriteNode.alpha = lcdOffAlpha
      bottomHorizontalBarrSKSpriteNode.alpha = lcdOnAlpha

      topLeftVerticalBarBarrSKSpriteNode.alpha = lcdOnAlpha
      topRightVerticalBarKSpriteNode.alpha = lcdOnAlpha
      bottomRightVerticalBarpriteNodepriteNode.alpha = lcdOnAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    case 1:
      topHorizontalBarSKSpriteNode.alpha = lcdOffAlpha
      middleHorizontalBarSKSpriteNode.alpha = lcdOffAlpha
      bottomHorizontalBarrSKSpriteNode.alpha = lcdOffAlpha

      topLeftVerticalBarBarrSKSpriteNode.alpha = lcdOffAlpha
      topRightVerticalBarKSpriteNode.alpha = lcdOnAlpha
      bottomRightVerticalBarpriteNodepriteNode.alpha = lcdOffAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    case 2:
      topHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      middleHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      bottomHorizontalBarrSKSpriteNode.alpha = lcdOnAlpha

      topLeftVerticalBarBarrSKSpriteNode.alpha = lcdOffAlpha
      topRightVerticalBarKSpriteNode.alpha = lcdOnAlpha
      bottomRightVerticalBarpriteNodepriteNode.alpha = lcdOnAlpha
      bottomRightVerticalBar.alpha = lcdOffAlpha
    case 3:
      topHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      middleHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      bottomHorizontalBarrSKSpriteNode.alpha = lcdOnAlpha

      topLeftVerticalBarBarrSKSpriteNode.alpha = lcdOffAlpha
      topRightVerticalBarKSpriteNode.alpha = lcdOnAlpha
      bottomRightVerticalBarpriteNodepriteNode.alpha = lcdOffAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    case 4:
      topHorizontalBarSKSpriteNode.alpha = lcdOffAlpha
      middleHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      bottomHorizontalBarrSKSpriteNode.alpha = lcdOffAlpha

      topLeftVerticalBarBarrSKSpriteNode.alpha = lcdOnAlpha
      topRightVerticalBarKSpriteNode.alpha = lcdOnAlpha
      bottomRightVerticalBarpriteNodepriteNode.alpha = lcdOffAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    case 5:
      topHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      middleHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      bottomHorizontalBarrSKSpriteNode.alpha = lcdOnAlpha

      topLeftVerticalBarBarrSKSpriteNode.alpha = lcdOnAlpha
      topRightVerticalBarKSpriteNode.alpha = lcdOffAlpha
      bottomRightVerticalBarpriteNodepriteNode.alpha = lcdOffAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    case 6:
      topHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      middleHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      bottomHorizontalBarrSKSpriteNode.alpha = lcdOnAlpha

      topLeftVerticalBarBarrSKSpriteNode.alpha = lcdOnAlpha
      topRightVerticalBarKSpriteNode.alpha = lcdOffAlpha
      bottomRightVerticalBarpriteNodepriteNode.alpha = lcdOnAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    case 7:
      topHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      middleHorizontalBarSKSpriteNode.alpha = lcdOffAlpha
      bottomHorizontalBarrSKSpriteNode.alpha = lcdOffAlpha

      topLeftVerticalBarBarrSKSpriteNode.alpha = lcdOffAlpha
      topRightVerticalBarKSpriteNode.alpha = lcdOnAlpha
      bottomRightVerticalBarpriteNodepriteNode.alpha = lcdOffAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    case 9:
      topHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      middleHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      bottomHorizontalBarrSKSpriteNode.alpha = lcdOnAlpha

      topLeftVerticalBarBarrSKSpriteNode.alpha = lcdOnAlpha
      topRightVerticalBarKSpriteNode.alpha = lcdOnAlpha
      bottomRightVerticalBarpriteNodepriteNode.alpha = lcdOffAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    default:
      topHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      middleHorizontalBarSKSpriteNode.alpha = lcdOnAlpha
      bottomHorizontalBarrSKSpriteNode.alpha = lcdOnAlpha

      topLeftVerticalBarBarrSKSpriteNode.alpha = lcdOnAlpha
      topRightVerticalBarKSpriteNode.alpha = lcdOnAlpha
      bottomRightVerticalBarpriteNodepriteNode.alpha = lcdOnAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    }
  }
}
